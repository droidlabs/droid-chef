# Mail settings for monit alerts
default["monit"]["mailserver"]["host"]            = 'smtp.gmail.com'
default["monit"]["mailserver"]["hostname"]        = nil
default["monit"]["mailserver"]["port"]            = 587
default["monit"]["mailserver"]["username"]        = 'alerts@droidlabs.pro'
default["monit"]["mailserver"]["password"]        = '4>m5DWJ711'
default["monit"]["mailserver"]["password_suffix"] = nil
default["monit"]["mailserver"]["encryption"]      = 'tlsv1'
default["monit"]["mailserver"]["timeout"]         = 60