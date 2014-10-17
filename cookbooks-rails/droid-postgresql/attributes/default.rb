#
# Cookbook Name:: droid-postgresql //Wrapper cookbook
# Attributes:: default
#
# Author:: Fadeev <fadeev2010@gmail.com>
#
# 
#

include_attribute "postgresql"  #LOAD default attributes for postrgresql
include_attribute "postgis"     # ????

# DROID ATTRIBUTIONS:
default["postgresql"]["version"]                         = "9.2"
default["postgresql"]["ssl"]                             = false