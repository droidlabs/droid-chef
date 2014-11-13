
# LOAD DEFAULT ATTRIBUTES

include_attribute "monit::default"

# DROID ATTRIBUTES

default["monit"]["notify_email"]           = 'alerts@droidlabs.pro'
default["monit"]["alert_blacklist"]        = %w( action instance pid ppid )

default["monit"]["logfile"]                = 'syslog facility log_daemon'

default["monit"]["poll_period"]            = 60
default["monit"]["poll_start_delay"]       = 240

default["monit"]["mail_format"]["subject"] = "$SERVICE $EVENT"
default["monit"]["mail_format"]["from"]    = "monit@#{node['fqdn']}"
default["monit"]["mail_format"]["message"] = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

default["monit"]["port"]     = 3737
default["monit"]["address"]  = nil
default["monit"]["ssl"]      = false
default["monit"]["cert"]     = "/etc/monit/monit.pem"
default["monit"]["allow"]    = []
default["monit"]["username"] = nil
default["monit"]["password"] = nil
default["monit"]["ssh_port"] = 22

default["monit"]["eventqueue"]["set"]     = true
default["monit"]["eventqueue"]["basedir"] = "/var/monit"
default["monit"]["eventqueue"]["slots"]   = 1000

# Load mail settings from attribute file (this file added in .gitignore)
include_attribute "droid-monit::mail_settings"

# # Mail settings for monit alerts
# default["monit"]["mailserver"]["host"]            = 'smtp.gmail.com'
# default["monit"]["mailserver"]["hostname"]        = nil
# default["monit"]["mailserver"]["port"]            = 587
# default["monit"]["mailserver"]["username"]        = 'User@gmail.com'
# default["monit"]["mailserver"]["password"]        = 'User_PASSWORD'
# default["monit"]["mailserver"]["password_suffix"] = nil
# default["monit"]["mailserver"]["encryption"]      = 'tlsv1'
# default["monit"]["mailserver"]["timeout"]         = 60

# set mailserver smtp.gmail.com port 587 
#     username "MYUSER" 
#     password "MYPASSWORD"
#     using tlsv1

