ports = node[:security][:default_ports].merge(node[:security][:ports])

template '/etc/iptables.rules' do
  source 'iptables.rules.erb'
  owner  'root'
  group  'root'
  mode   '0700'
  variables(ports: ports)
end

bash 'iptables-restore < /etc/iptables.rules' do
  user 'root'
  code <<-EOH
    iptables-restore < /etc/iptables.rules
    EOH
end

bash 'iptables.rules to interfaces' do
  user 'root'
  code <<-EOF
    echo "pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces
  EOF
  not_if "cat /etc/network/interfaces | grep iptables.rules"
end
