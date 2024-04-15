#!/bin/bash
# Project starting bash script for Pop!_OS (Ubuntu *might* work)

# Script specific vars
SCRIPT_LABEL='with Pop!_OS support'
SCRIPT_VERSION='1.0.1 (2024-04-15)'

# Vars needed for this file to function globally
CURRENTFILE=`basename $0`

# Determine scripts location to get imports right
if [ "$CURRENTFILE" = "popos.sh" ]; then
  SCRIPTS_LOCATION="$( pwd )"
  source ${SCRIPTS_LOCATION}/tasks/variables.sh
  source ${SCRIPTS_LOCATION}/tasks/header.sh
  exit
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  ORIGINAL_FILE=$( readlink $DIR/$CURRENTFILE )
  SCRIPTS_LOCATION=$( dirname $ORIGINAL_FILE )

  source ${SCRIPTS_LOCATION}/tasks/variables.sh # Colors
fi

# Final note about server requirements
echo ""
echo "${TXTRESET}${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/raikasdev/pop-lemp-setup
${TXTRESET}"
echo ""

# Server needs to be on...
echo "${YELLOW}Ensuring web server is on...${TXTRESET}"
function ensure_server_on {
    # Let's just check the status to not require sudo
    systemctl is-active --quiet nginx && systemctl is-active --quiet php8.3-fpm && systemctl is-active --quiet mysql && return 0

    # If all services start without problem, this function will return and exit
    sudo systemctl start nginx && sudo systemctl start php8.3-fpm && sudo systemctl start mysql && return 0

    # If some service fails to start, the function will not return and the createproject program will exit.
    echo "${RED}LEMP stack failed to start! Exiting.${TXTRESET}"
    exit 1
}

ensure_server_on

# Existing project import
source ${SCRIPTS_LOCATION}/tasks/existing.sh

# Import required tasks
source ${SCRIPTS_LOCATION}/tasks/imports.sh

# Update hosts and restart nginx
echo "${YELLOW}Updating hosts file...${TXTRESET}"
sudo -- sh -c "echo 127.0.0.1 ${PROJECTNAME}.test >> /etc/hosts"

echo "${YELLOW}Restarting nginx...${TXTRESET}"
sudo systemctl stop nginx
sudo systemctl start nginx
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"

# The end
source ${SCRIPTS_LOCATION}/tasks/footer.sh
