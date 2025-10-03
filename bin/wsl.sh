#!/bin/bash
# Project starting bash script for WSL native LEMP.
# More info: https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development

# Script specific vars
SCRIPT_LABEL='with WSL support'
SCRIPT_VERSION='1.0.6 (2025-10-03)'

# Vars needed for this file to function globally
CURRENTFILE=`basename $0`

# Determine scripts location to get imports right
if [ "$CURRENTFILE" = "wsl.sh" ]; then
  SCRIPTS_LOCATION="$( pwd )"
  source ${SCRIPTS_LOCATION}/tasks/variables.sh
  source ${SCRIPTS_LOCATION}/tasks/header.sh
  exit
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  ORIGINAL_FILE=$( readlink $DIR/$CURRENTFILE )
  SCRIPTS_LOCATION=$( dirname $ORIGINAL_FILE )
fi

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/windows-lemp-setup
${TXTRESET}"

# Server on WSL needs to be on before starting
echo "${YELLOW}Starting web server...${TXTRESET}"
sudo service nginx start
sudo service php8.3-fpm start
sudo service mysql start

# Import required tasks
source ${SCRIPTS_LOCATION}/tasks/imports.sh

# WSL specific restarts
echo "${YELLOW}Restarting nginx...${TXTRESET}"
sudo service nginx stop
sudo service nginx start
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"

# WSL specific complete message
echo "${BOLDYELLOW}Almost done! Use HostsFileEditor https://github.com/scottlerch/HostsFileEditor and add 127.0.0.1 $PROJECTNAME.test to your Windows hosts file (Windows does not let to update this via command line).${TXTRESET}"

# The end
source ${SCRIPTS_LOCATION}/tasks/footer.sh
