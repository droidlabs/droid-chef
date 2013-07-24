# Chef recipes bundle for Rails applications

## GETTING STARTED

### Setup ssh

* $ brew install ssh-copy-id
* $ ssh-copy-id root@yourserver.com

### bundle and update cookbooks

* $ bundle install
* $ librarian-chef install

### Prepare server first time

* $ cp nodes/example.com.json nodes/yourserver.com.json
* $ knife solo prepare root@yourserver.com

### Cook

* $ knife solo cook root@yourserver.com

### Notes

* this chef recipes build for using on Ubuntu 12.04 LTS

## TEST WITH VAGRANT

* $ cp nodes/example.com.json nodes/localhost.json
* $ vagrant up
* $ knife solo prepare vagrant@localhost --ssh-port 2222
* $ knife solo cook vagrant@localhost --ssh-port 2222