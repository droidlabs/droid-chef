template "/etc/iptables.rules" do
  source "iptables.rules.erb"
  owner  "root"
  group  "root"
  mode   "0700"
end
bash "iptables-restore < /etc/iptables.rules"
bash "iptables.rules to interfaces" do
  user "root"
  code <<-EOF
    echo "pre-up iptables-restore < /etc/iptables.rules" >> /etc/network/interfaces
  EOF
  not_if "cat /etc/network/interfaces | grep iptables.rules"
end