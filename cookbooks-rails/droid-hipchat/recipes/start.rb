hip_message_start = node[:hipchat][:message_start]

package "curl"

if node[:hipchat][:hip_token]
  hipchat hip_message_start do
    hip_color   node[:hipchat][:hip_color] 
    hip_token   node[:hipchat][:hip_token]
    hip_from    node[:hipchat][:hip_from]
    hip_room    node[:hipchat][:hip_room]
  end	
end