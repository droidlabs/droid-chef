# figure out where ruby is.  We have this kind of cumbersome thing
# since rvm may or may not be installed.

class Chef
  class Recipe
    def run_passenger_config *opts
      return system("sudo -u #{node[:deploy_user][:username]} -i passenger-config #{opts * ' '}")
    end
  end
end
