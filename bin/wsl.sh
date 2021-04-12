#!/bin/bash
# Project starting bash script for WSL native LEMP.
# More info: https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development

# Import required variables
source tasks/variables.sh

# Script specific vars
SCRIPT_LABEL='with WSL support'
SCRIPT_VERSION='1.0.3'

# Script header
source tasks/header.sh

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/windows-lemp-setup
${TXTRESET}"
echo ""

# Ask names and credentials
source tasks/askvars.sh

# Init project and run composer
source tasks/initproject.sh

# Create database
source tasks/initdb.sh

# Clean up files that are not needed
source tasks/cleanups.sh

# Update .env
source tasks/dotenv.sh

# WP-Cli and WP installation
source tasks/wp-cli.sh

# Set up permissions
source tasks/permissions.sh

# SSL certificates
source tasks/certs.sh

# Init GitHub company repository
source tasks/github.sh

# Set up virtual hosts
source tasks/vhosts.sh

# WSL specific restarts
echo "${YELLOW}Restarting nginx...${TXTRESET}"
sudo service nginx stop
sudo service nginx start
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"

# WSL specific complete message
echo "${BOLDYELLOW}Almost done! Use HostsFileEditor https://github.com/scottlerch/HostsFileEditor and add 127.0.0.1 $PROJECTNAME.test to your Windows hosts file (Windows does not let to update this via command line).${TXTRESET}"

# The end
source tasks/footer.sh
