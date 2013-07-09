knife[:provisioning_path] = "~/chef-solo"
cookbook_path ["cookbooks", "cookbooks-rails"]
node_path     "nodes"
role_path     "roles"
data_bag_path "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"