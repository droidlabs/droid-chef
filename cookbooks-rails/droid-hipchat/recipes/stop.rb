
hip_message = "Server+#{node.fqdn}+Chef+Recipies+FINISHED" # use plus instead of a space
hip_color   = "green" # "yellow", "red", "green", "purple", "gray", or "random". (default: yellow)
hip_from    = "ChefBot"
hip_room    = "Servers"

if node[:hipchat][:hip_token]
  hipchat hip_message do
    hip_color   hip_color 
    hip_token   node[:hipchat][:hip_token]
    hip_from    hip_from
    hip_room    hip_room
  end
end  