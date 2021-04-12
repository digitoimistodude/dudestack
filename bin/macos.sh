#!/bin/bash
# Project starting bash script for macOS native LEMP.
# More info: https://github.com/digitoimistodude/macos-lemp-setup

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# echo $DIR
# exit

# Script specific vars
SCRIPT_LABEL='for macOS'
SCRIPT_VERSION='1.0.4'

# Vars needed for this file to function globally
PROJECTS_HOME="/var/www"
DUDESTACK_LOCATION="${PROJECTS_HOME}/dudestack"

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/macos-lemp-setup
${TXTRESET}"

# Import required tasks
source ${DUDESTACK_LOCATION}/bin/tasks/imports.sh

# MacOS Specific restarts and reloads
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"
echo "${YELLOW}Updating hosts file...${TXTRESET}"
sudo -- sh -c "echo 127.0.0.1 ${PROJECTNAME}.test >> /etc/hosts"
sudo brew services stop nginx
sudo brew services start nginx

# macOS specific complete message
echo "${BOLDGREEN}All done!${TXTRESET}"

# The end
source ${DUDESTACK_LOCATION}/bin/tasks/footer.sh
