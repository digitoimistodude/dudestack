#!/bin/bash
# Project starting bash script for macOS native LEMP.
# More info: https://github.com/digitoimistodude/macos-lemp-setup

# Import required variables
source tasks/variables.sh

# Script specific vars
SCRIPT_LABEL='for macOS'
SCRIPT_VERSION='1.0.3'

# Script header
source tasks/header.sh

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/macos-lemp-setup
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

# MacOS Specific restarts and reloads
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"
echo "${YELLOW}Updating hosts file...${TXTRESET}"
sudo -- sh -c "echo 127.0.0.1 ${PROJECTNAME}.test >> /etc/hosts"
sudo brew services stop nginx
sudo brew services start nginx

# macOS specific complete message
echo "${BOLDGREEN}All done!"

# The end
source tasks/footer.sh
