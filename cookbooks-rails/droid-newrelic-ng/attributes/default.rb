
include_attribute "newrelic-ng::defaults"

default['newrelic-ng']['license_key'] = '323b2369e30c8b36df9a966c30966d95cb7df67e'

default['newrelic-ng']['user']['name']   = 'newrelic'
default['newrelic-ng']['user']['group']  = 'newrelic'
default['newrelic-ng']['user']['shell']  = '/bin/sh'
default['newrelic-ng']['user']['system'] = true

default['newrelic-ng']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i386'
