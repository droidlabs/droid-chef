# if node[:security][:additional_ports] && node[:security][:additional_ports].any?
#   raise "security[additional_ports] is deprecated. please use security[ports] with reverted hash syntax."
# end

ports = node[:security][:default_ports].merge(node[:security][:ports])

template "/etc/iptables.rules" do
  source "iptables.rules.erb"
  owner  "root"
  group  "root"
  mode   "0700"
  variables(ports: ports)
end

bash "iptables-restore < /etc/iptables.rules"
bash "iptables.rules to interfaces" do
  user "root"
  code <<-EOF
    echo "pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces
  EOF
  not_if "cat /etc/network/interfaces | grep iptables.rules"
end