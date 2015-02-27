

#=========POSTFIX ATTRIBUTES WITH RELAY GMAIL===============================

include_attribute "postfix::default"

# default["postfix"]["mail_type"]                     =  "master"
# 
# default["postfix"]["main"] = {  "relayhost" =>  "[smtp.gmail.com]:587" }
# 
# default["postfix"]["main"]["smtp_sasl_auth_enable"] =  "yes"

default["postfix"]["use_alias_maps"] = true
default["postfix"]["aliases"] = {  "ninja"  =>  "root",
                                   "monit"  =>  "root"
                                }

default["postfix"]["use_transport_maps"] = true
default["postfix"]["transports"] = {  "*" => "smtp:[smtp.gmail.com]:587"
                                   }

default["postfix"]["smtp_generic_map_entries"] =
        {  "@#{node["hostname_change"]}"             =>  "alerts@droidlabs.pro",
           "@#{node["hostname_change"]}.local"       =>  "alerts@droidlabs.pro",
           "@#{node["hostname_change"]}.localdomain" =>  "alerts@droidlabs.pro",
           "@local"       =>  "alerts@droidlabs.pro",
           "@localhost"   =>  "alerts@droidlabs.pro"
        }
