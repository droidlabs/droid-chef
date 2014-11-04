# Wrapper-cookbook elasticsearch

include_recipe 'elasticsearch::default'

# Make sure the service is started
#
service("elasticsearch") { action :start }
