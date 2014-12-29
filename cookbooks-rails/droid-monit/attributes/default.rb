
# LOAD DEFAULT ATTRIBUTES

include_attribute "monit::default"

# DROID ATTRIBUTES

default["monit"]["notify_email"]           = 'alerts@droidlabs.pro'
default["monit"]["alert_blacklist"]        = %w( action instance pid ppid )

default["monit"]["logfile"]                = '/var/log/monit.log'

default["monit"]["poll_period"]            = 60
default["monit"]["poll_start_delay"]       = 240

default["monit"]["mail_format"]["subject"] = "Monit #{ node.name } $SERVICE $EVENT"
default["monit"]["mail_format"]["from"]    = node["monit"]["mailserver"]["username"]
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
default["monit"]["username"] = "#{node[:deploy_user][:username]}" || 'guest_monit'
default["monit"]["password"] = "#{node[:deploy_user][:password]}" || 'guest_monit'
default["monit"]["ssh_port"] = 22

default["monit"]["eventqueue"]["set"]     = true
default["monit"]["eventqueue"]["basedir"] = "/var/monit"
default["monit"]["eventqueue"]["slots"]   = 1000

# Mail settings for monit alerts

# From nodelist
# default["monit"]["mailserver"]["host"]            = 'smtp.gmail.com'
# default["monit"]["mailserver"]["port"]            = 587
# default["monit"]["mailserver"]["username"]        = 'alerts@hostname.pro'
# default["monit"]["mailserver"]["password"]        = 'MAIL_PASSWORD'
# default["monit"]["mailserver"]["encryption"]      = 'tlsv1'
default["monit"]["mailserver"]["timeout"]         = 60
default["monit"]["mailserver"]["hostname"]        = nil
default["monit"]["mailserver"]["password_suffix"] = nil
