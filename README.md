# Chef recipes bundle for Ruby applications

## GETTING STARTED

### Setup ssh

* `$ brew install ssh-copy-id`
* `$ ssh-copy-id root@yourserver.com`

### bundle and update cookbooks

* `$ bundle install`
* `$ librarian-chef install`

### Prepare server first time

* `$ cp nodes/example.com.json nodes/yourserver.com.json`
* `$ knife solo prepare root@yourserver.com`

### Cook

* `$ knife solo cook root@yourserver.com`

### Notes

* this chef recipes build for using on Ubuntu 12.04/14.04 LTS

## TEST WITH VAGRANT

* Download and install Vagrant - http://www.vagrantup.com/downloads.html
* Download and install VirtualBox - https://www.virtualbox.org/wiki/Downloads
* `$ vagrant box add ubuntu/trusty64`
* `$ vagrant up`
* `$ knife solo prepare vagrant@127.0.0.1 --ssh-port 2222 --identity-file ~/.vagrant.d/insecure_private_key`
* `$ knife solo cook vagrant@127.0.0.1 --ssh-port 2222 --identity-file ~/.vagrant.d/insecure_private_key`
* `$ vagrant halt`

## CAPISTRANO

* If you are using Capistrano:
* 1) adding in deploy.rb: 
* ` set :default_environment, {`
	`	'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"`
	`}`
* 2) remove require 'capistrano-rbenv'