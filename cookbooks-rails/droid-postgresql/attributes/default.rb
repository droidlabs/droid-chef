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

# DROID ATTRIBUTIONS: --------------------------------------------------
default["postgresql"]["version"]                         = "9.2"
default["postgresql"]["ssl"]                             = false
default["postgresql"]["pg_hba_defaults"]                 = false

default["postgresql"]["pg_hba"]                          = [
"local  all   all                 trust",  
"host   all   all   127.0.0.1/32  trust",  
"host   all   all   localhost     trust",  
"host   all   all   ::1/128       trust" 
 		 ]

 