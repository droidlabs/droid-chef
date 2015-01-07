## 0.2.5
* Create custom nginx config for each app at sites.d/custom/app_name.custom.conf
* Support adding pg_extensions on cook
* Thin host works via sockets now
* Bug fixes

## 0.2.4
* Chef will generate "system" folder in shared for Rails
* Chef will add RUBY_ENV and RAILS_ENV to app user
* Support chef 12
* Ability to setup nginx workers count
* Refactored nginx host templates
* Added "static" nginx host
* Added hipchat message support
* Create symlink to application in app user home folder