
# DROID BACKUP
deploy_user         = node[:deploy_user][:username]
database_pwd        = node[:deploy_user][:database_password]
database_root_pwd   = node[:deploy_user][:database_root_password]

backup_gem_bin_dir  = node[:backup][:gem_bin_dir]
cron_hour           = node[:backup][:cron_hour]
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
    's3.access_key_id'      => s3_access_key_id,
    's3.secret_access_key'  => s3_secret_access_key,
    's3.region'             => s3_region,
    's3.bucket'             => s3_bucket,
    's3.path'               => '/',
    's3.keep'               => s3_keep
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

backup_enabled = node[:redis][:backup_enabled]

if backup_enabled
  backup_generate_model "redis" do
    description   "#{node.name} backup of redis"
    backup_type   'database'
    database_type 'Redis'
          # split_into_chunks_of 2048
    store_with    settings_s3
    options       ({
                      'db.mode'     => ":sync",
                      'db.rdb_path' => "\"/var/lib/redis/prime/dump.rdb\"",
                      'db.additional_options' => "[]",
                      'db.invoke_save' => "false"
                  })
    mailto        backup_mailto
    action        :backup
    hour          cron_hour
    gem_bin_dir   backup_gem_bin_dir
    after_hook    after_hook_notifier
  end
else
  backup_generate_model "redis" do
    action :disable
  end
end
