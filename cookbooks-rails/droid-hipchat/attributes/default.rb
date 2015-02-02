# hip_token
default[:hipchat][:hip_token] = ""

# hip_message_start # use plus instead of a space
default[:hipchat][:message_start] = "Server+#{node.fqdn}+Chef+Recipies+STARTED"

# hip_message_stop  # use plus instead of a space
default[:hipchat][:message_stop]  = "Server+#{node.fqdn}+Chef+Recipies+FINISHED"


# hip_color  # "yellow", "red", "green", "purple", "gray", or "random". (default: yellow)
default[:hipchat][:hip_color] = "red"

# hip_from   
default[:hipchat][:hip_from]  = "ChefBot"

# hip_room   
default[:hipchat][:hip_room]  = "Servers"
