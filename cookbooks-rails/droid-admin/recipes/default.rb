
# Setting The Time Zone
include_recipe 'timezone::default'

# recipe install admin pkg
['htop', 'mc', 'iotop'].each do |pkg|
  package pkg do
    action :upgrade
  end
end

if node['hostname_change']
  bash 'Change server hostname' do
      user 'root'
      cwd '/tmp'
      code <<-EOH
        sudo hostname #{node['hostname_change']}  
      EOH
  end
end
