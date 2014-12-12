define :hipchat do

bash  "send message to hipchat" do
  code <<-EOH
    curl -d "room_id=#{params[:hip_room]}&from=#{params[:hip_from]}&message=#{params[:name]}&notify=1&color=#{params[:hip_color]}" https://api.hipchat.com/v1/rooms/message\?auth_token\=#{params[:hip_token]}\&format\=json
  EOH
end

end
