template "/etc/iptables.sh" do
  source "iptables.sh"
  owner  "root"
  group  "root"
  mode   "0700"
end
bash "sh /etc/iptables.sh"

template "/etc/rc.local" do
  source "rc.local"
  owner  "root"
  group  "root"
  mode   "0644"
end