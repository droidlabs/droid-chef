
include_attribute "rbenv::default"

default['deployer_ruby']['gems'] = ["bundler", "daemons"]

# ALL Ruby versions from node settings #
main_ruby_version = node[:deploy_user][:ruby_version]
app_ruby_versions = node[:applications].map { |a| a[:ruby_version] }.compact
ruby_versions = ([main_ruby_version] + app_ruby_versions).uniq

gems_hash = {}
ruby_versions.each do |version|
  gems_hash[version] = node[:deployer_ruby][:gems].map{ |g| {name: g} }
end

default['rbenv']['root_path'] = "/usr/local/rbenv" #"/opt/rbenv"
default['rbenv']['rubies']    = ruby_versions
default['rbenv']['global']    = main_ruby_version
default['rbenv']['gems'] 	  = gems_hash

## env variables
# EC2 server flags
default['rbenv']['env_variables'] = %Q{CHOST="x86_64-pc-linux-gnu" CFLAGS="-march=nocona -O2 -pipe" CXXFLAGS="${CFLAGS}"}

# Rackspace server flags
# default['rbenv']['env_variables'] = %Q{CHOST="x86_64-pc-linux-gnu" CFLAGS="-march=k8 -O2 -pipe" CXXFLAGS="${CFLAGS}"}
# More info http://en.gentoo-wiki.com/wiki/Safe_Cflags/Intel#Intel_Core_Solo.2FDuo.2C_Pentium_Dual-Core_T20xx.2FT21xx

## configuration options
default['rbenv']['opt_variables'] = "--with-iconv-dir=/usr/bin"