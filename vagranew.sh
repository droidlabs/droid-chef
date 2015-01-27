#!/bin/bash
# Droidlabs.pro Fadeev Sergey

# Remove WM !!! FORCING this out confirmation
vagrant destroy -f &&

# Create a new WM
vagrant up &&

# Remove the keys for the old WM
ssh-keygen -f ~/.ssh/known_hosts -R [127.0.0.1]:2222 &&

# Copy new key
# ssh-copy-id vagrant@127.0.0.1 -p2222 &&

# Prepare new WM
# knife solo prepare vagrant@127.0.0.1 -p 2222 &&
knife solo prepare vagrant@127.0.0.1 --ssh-port 2222 --identity-file ~/.vagrant.d/insecure_private_key &&
 
# Cook recipes from node 127.0.0.1.json
# knife solo cook vagrant@127.0.0.1 -p 2222
knife solo cook vagrant@127.0.0.1 --ssh-port 2222 --identity-file ~/.vagrant.d/insecure_private_key