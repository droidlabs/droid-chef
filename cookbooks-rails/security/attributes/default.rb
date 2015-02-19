default[:security][:default_ports] = {'22' => 'all', '80' => 'all', '443' => 'all'}
default[:security][:ports] = {}

#================== FAIL2BAN ====================
include_attribute 'fail2ban::default'

# jail.conf configuration options
default['fail2ban']['ignoreip'] = '127.0.0.1/8'
default['fail2ban']['findtime'] = 600
default['fail2ban']['bantime'] = 1800
default['fail2ban']['maxretry'] = 3

default['fail2ban']['services'] = {
  'ssh' => {
        'enabled' => 'true',
        'port' => 'ssh',
        'filter' => 'sshd',
        'logpath' => node['fail2ban']['auth_log'],
        'maxretry' => '3'
     }
}
