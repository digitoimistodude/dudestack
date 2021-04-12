#!/bin/bash
# Project starting bash script for WSL native LEMP.
# More info: https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development

# Script specific vars
SCRIPT_LABEL='with WSL support'
SCRIPT_VERSION='1.0.4'

# Vars needed for this file to function globally
PROJECTS_HOME="/var/www"
DUDESTACK_LOCATION="${PROJECTS_HOME}/dudestack"

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/windows-lemp-setup
${TXTRESET}"

# Import required variables
source ${DUDESTACK_LOCATION}/bin/tasks/variables.sh

# Script header
source ${DUDESTACK_LOCATION}/bin/tasks/header.sh

# Ask names and credentials
source ${DUDESTACK_LOCATION}/bin/tasks/askvars.sh

# Init project and run composer
source ${DUDESTACK_LOCATION}/bin/tasks/initproject.sh

# Create database
source ${DUDESTACK_LOCATION}/bin/tasks/initdb.sh

# Update .env
source ${DUDESTACK_LOCATION}/bin/tasks/dotenv.sh

# WP-Cli and WP installation
source ${DUDESTACK_LOCATION}/bin/tasks/wp-cli.sh

# Clean up files that are not needed
source ${DUDESTACK_LOCATION}/bin/tasks/cleanups.sh

# Set up permissions
source ${DUDESTACK_LOCATION}/bin/tasks/permissions.sh

# SSL certificates
source ${DUDESTACK_LOCATION}/bin/tasks/certs.sh

# Init GitHub company repository
source ${DUDESTACK_LOCATION}/bin/tasks/github.sh

# Set up virtual hosts
source ${DUDESTACK_LOCATION}/bin/tasks/vhosts.sh

# WSL specific restarts
echo "${YELLOW}Restarting nginx...${TXTRESET}"
sudo service nginx stop
sudo service nginx start
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"

# WSL specific complete message
echo "${BOLDYELLOW}Almost done! Use HostsFileEditor https://github.com/scottlerch/HostsFileEditor and add 127.0.0.1 $PROJECTNAME.test to your Windows hosts file (Windows does not let to update this via command line).${TXTRESET}"

# The end
source ${DUDESTACK_LOCATION}/bin/tasks/footer.sh
