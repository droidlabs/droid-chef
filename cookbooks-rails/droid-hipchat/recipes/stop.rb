
hip_message_stop = node[:hipchat][:message_stop]

if node[:hipchat][:hip_token]
  hipchat hip_message_stop do
    hip_color   node[:hipchat][:hip_color_stop] 
    hip_token   node[:hipchat][:hip_token]
    hip_from    node[:hipchat][:hip_from]
    hip_room    node[:hipchat][:hip_room]
  end
end  