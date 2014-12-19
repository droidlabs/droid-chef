
# DROID BACKUP
deploy_user         = node[:deploy_user][:username]
database_pwd        = node[:deploy_user][:database_password]
database_root_pwd   = node[:deploy_user][:database_root_password]

backup_gem_bin_dir  = node[:backup][:gem_bin_dir]
cron_hour           = node[:backup][:cron_hour]
cron_path           = node[:backup][:cron_path]
backup_mailto       = node[:backup][:mailto]
backup_base_dir     = node[:backup][:base_dir]

# AWS s3 config
s3_access_key_id      = node[:backup][:s3][:aws_access_key]
s3_secret_access_key  = node[:backup][:s3][:aws_secret_key]
s3_region             = node[:backup][:s3][:bucket_region]
s3_bucket             = node[:backup][:s3][:bucket_name]
s3_keep               = node[:backup][:s3][:keep]

settings_s3 = {
  'engine' => 'S3',
  'settings' => {
    's3.access_key_id' 			=> s3_access_key_id,
    's3.secret_access_key' 	=> s3_secret_access_key,
    's3.region' 						=> s3_region,
    's3.bucket'             => s3_bucket,
    's3.path' 							=> '/',
    's3.keep' 							=> s3_keep
  }
}

after_hook_notifier = 'notify_by Mail'

# INSTALL BACKUP GEM
backup_install node.name

# GENERATE CONFIG
backup_generate_config node.name do
  base_dir backup_base_dir
  cookbook 'droid-backup'
end
gem_package 'fog' do
  version '~> 1.4.0'
end

# GENERATE MODEL BACKUP DATABASES AND FILES
node[:applications].each do |app|

  backup = app[:backup] || {}
  db_backup_enabled = !backup.has_key?(:database) || backup[:database]
  files_backup_enabled = !backup.has_key?(:files) || backup[:files]

  if app[:database] == 'postgresql' && db_backup_enabled
    backup_generate_model "#{app[:name]}_db_pg" do
      description   "#{node.name} backup of postgres"
      backup_type   'database'
      database_type 'PostgreSQL'
            # split_into_chunks_of 2048
      store_with    settings_s3
      options       ({
                        'db.name'     => "\"#{app[:name]}\"",
                        'db.username' => "\"#{deploy_user}\"",
                        'db.password' => "\"#{database_pwd}\"",
                        'db.host' 		=> "\"localhost\""
                    })
      mailto        backup_mailto
      action        :backup
      hour          cron_hour
      cron_path     cron_path
      gem_bin_dir   backup_gem_bin_dir
      after_hook    after_hook_notifier
    end
  else
    backup_generate_model "#{app[:name]}_db_pg" do
      action :disable
    end
  end

  if app[:database] == 'mysql' && db_backup_enabled
    backup_generate_model "#{app[:name]}_db_mysql" do
      description "#{node.name} backup of mysql"
      backup_type 'database'
      database_type 'MySQL'
      # split_into_chunks_of 2048
      store_with    ( settings_s3 )
      options 			({
                        "db.name" => "\"#{app[:name]}\"",
                        "db.username" => "\"#{deploy_user}\"",
                        "db.password" => "\"#{database_root_pwd}\"",
                        "db.host" => "\"localhost\""
                      }
                    )  
      mailto        backup_mailto
      action        :backup
      hour          cron_hour
      cron_path     cron_path
      gem_bin_dir   backup_gem_bin_dir
      after_hook    after_hook_notifier
    end
  else
    backup_generate_model "#{app[:name]}_db_mysql" do
      action :disable
    end
  end
  if app[:database] == 'mongodb' && db_backup_enabled
    backup_generate_model "#{app[:name]}_db_mongodb" do  
      description "#{node.name} Our shard mongodb"  
      backup_type "database"  
      database_type "MongoDB"  
      # split_into_chunks_of 2048  
      store_with    ( settings_s3 )
      options({"db.host" => "\"localhost\"", "db.lock" => true})
      mailto 				backup_mailto
      action 				:backup
      hour 					cron_hour
      cron_path     cron_path
      gem_bin_dir   backup_gem_bin_dir
      after_hook    after_hook_notifier
    end
  else
  	backup_generate_model "#{app[:name]}_db_mongodb" do
  		action :disable
  	end  
  end
  # Archiving files to S3
  if files_backup_enabled
    backup_generate_model "#{app[:name]}_files_backup" do
      description "#{node.name} backup #{app[:name]} files"
      backup_type 'archive'
      # split_into_chunks_of 250
      store_with	( settings_s3 )
      options ({ 'add' => [ "/data/#{app[:name]}/shared/system" ],
      					 # 'exclude' => ['/home/tmp'],
      					 'tar_options' => '-p'
      					}
      				)
      mailto        backup_mailto
      action        :backup
      hour 	        cron_hour
      cron_path     cron_path
      gem_bin_dir   backup_gem_bin_dir
      after_hook    after_hook_notifier
    end
  else
  	backup_generate_model "#{app[:name]}_files_backup" do
  		action :disable
  	end  
	end
end

#Setup logrotate config for Backup logs
template "/etc/logrotate.d/backup_gem_log" do
  owner "root"
  source "logrotate.erb"
  variables(backup_path: backup_base_dir)
end
