file_cache_path           "/tmp/chef-solo"
data_bag_path             "/tmp/chef-solo/data_bags"
encrypted_data_bag_secret "/tmp/chef-solo/data_bag_key"
cookbook_path             [ "/tmp/chef-solo/cookbooks-rails",
                            "/tmp/chef-solo/cookbooks" ]
role_path                 "/tmp/chef-solo/roles"


# if user for knife do not have access to /tmp without sudo, 
# e.g. when you use "ubuntu" user, please use something like:

# file_cache_path           "/home/ubuntu/chef-solo-tmp"
# data_bag_path             "/home/ubuntu/chef-solo-tmp/data_bags"
# encrypted_data_bag_secret "/home/ubuntu/chef-solo-tmp/data_bag_key"
# cookbook_path             [ "/home/ubuntu/chef-solo-tmp/cookbooks-rails",
#                             "/home/ubuntu/chef-solo-tmp/cookbooks" ]
# role_path                 "/home/ubuntu/chef-solo-tmp/roles"