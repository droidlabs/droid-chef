
# Setting The Time Zone
include_recipe "timezone::default"

# recipe install admin pkg
["htop", "mc", "iotop"].each do |pkg|
  package pkg do
    action :upgrade
  end
end

if node["hostname_change"]
  bash "Change server hostname" do
    user "root"
    cwd "/tmp"
    code <<-EOH
      sudo hostname #{node["hostname_change"]}
    EOH
  end
end

#====== INSTALL POSTFIX ==============

include_recipe "postfix::default"

bash "install postfix cert" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem |
      sudo tee -a /etc/postfix/cacert.pem
  EOH
  notifies :restart, "service[postfix]"
  not_if do ::File.exist?("/etc/postfix/cacert.pem") end
end
