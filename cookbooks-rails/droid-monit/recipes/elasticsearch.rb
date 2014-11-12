include_recipe "droid-monit"

monitrc "droid-elasticsearch" do
    template_cookbook "droid-monit"
    template_source   "droid-elasticsearch.conf.erb"
end