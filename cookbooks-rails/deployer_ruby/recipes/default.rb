ruby_version = node[:deploy_user][:ruby_version]
deploy_username = node[:deploy_user][:username]

node.set[:rbenv][:user_installs] = [{
  user: deploy_username,
  rubies: [ruby_version],
  global: ruby_version,
  gems: {
    ruby_version => [{ name: "bundler" },{ name: "rake" },{ name: "passenger" }]
  }
}]

## env variables
# EC2 server flags
node.set[:rbenv][:env_variables] = %Q{CHOST="x86_64-pc-linux-gnu" CFLAGS="-march=nocona -O2 -pipe" CXXFLAGS="${CFLAGS}"}
# Rackspace server flags
# node[:rbenv][:env_variables] = %Q{CHOST="x86_64-pc-linux-gnu" CFLAGS="-march=k8 -O2 -pipe" CXXFLAGS="${CFLAGS}"}
# More info http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel#Intel_Core_Solo.2FDuo.2C_Pentium_Dual-Core_T20xx.2FT21xx

## configuration options
node.set[:rbenv][:opt_variables] = "--with-iconv-dir=/usr/bin"