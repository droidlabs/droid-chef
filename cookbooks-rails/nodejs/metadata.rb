maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures Node.js and npm."
version           "0.0.8"
recipe            "nodejs", "Installs and configures Node.js and npm"

depends "build-essential"

%w{ ubuntu }.each do |os|
    supports os
end

