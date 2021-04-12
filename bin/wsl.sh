#!/bin/bash
# Project starting bash script for WSL native LEMP by rolle.
# More info: https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development

# Import required variables
source helpers/variables.sh

# Script specific vars
SCRIPT_LABEL='with WSL support'
SCRIPT_VERSION='1.0.2'

# Script header
source helpers/header.sh

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/windows-lemp-setup
${TXTRESET}"
echo ""

# Ask names and credentials
source helpers/askvars.sh

# Init project and run composer
source helpers/initproject.sh

# Create database
source helpers/initdb.sh

# Clean up files that are not needed
source helpers/cleanups.sh

# Update .env
source helpers/dotenv.sh

# Update .env
source helpers/installwp.sh

# WP-Cli and WP installation
source helpers/wp-cli.sh

# Set up permissions
source helpers/permissions.sh

# SSL certificates
source helpers/certs.sh

# Set up virtual hosts
source helpers/vhosts.sh

# Restarts
source helpers/restarts.sh

# WSL specific complete message
echo "${BOLDYELLOW}Almost done! Use HostsFileEditor https://github.com/scottlerch/HostsFileEditor and add 127.0.0.1 $PROJECTNAME.test to your Windows hosts file (Windows does not let to update this via command line).${TXTRESET}"
echo ""

# The end
source helpers/footer.sh
