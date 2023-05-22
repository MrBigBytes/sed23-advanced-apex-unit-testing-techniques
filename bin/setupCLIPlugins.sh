#!/bin/bash
# 
# bin/setupCLIPlugins.sh
# 

# exit script when any command failes
set -e 

# install the @dx-cli-toolbox/sfdx-toolbox-package-utils plugin
#   for more information, see https://www.npmjs.com/package/@dx-cli-toolbox/sfdx-toolbox-package-utils
echo y | sfdx plugins:install @dx-cli-toolbox/sfdx-toolbox-package-utils
