default[:backup][:name] = "server_backup"
default[:backup][:description] = "a chef generated server backup"


default[:backup][:s3][:aws_access_key] = ""
default[:backup][:s3][:aws_secret_key] = ""
default[:backup][:s3][:bucket_region] = 'us-east-1'
default[:backup][:s3][:bucket_name] = ''
default[:backup][:s3][:keep] = '10'

default[:backup][:s3][:sync_path] = "/files"