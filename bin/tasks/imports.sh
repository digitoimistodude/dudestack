# Import required variables
source ${SCRIPTS_LOCATION}/tasks/variables.sh

# Script header
source ${SCRIPTS_LOCATION}/tasks/header.sh

# Ask names and credentials
source ${SCRIPTS_LOCATION}/tasks/askvars.sh

# Init project and run composer
source ${SCRIPTS_LOCATION}/tasks/initproject.sh

# Create database
source ${SCRIPTS_LOCATION}/tasks/initdb.sh

# Update .env
source ${SCRIPTS_LOCATION}/tasks/dotenv.sh

# WP-Cli and WP installation
source ${SCRIPTS_LOCATION}/tasks/wp-cli.sh

# Clean up files that are not needed
source ${SCRIPTS_LOCATION}/tasks/cleanups.sh

# Set up permissions
source ${SCRIPTS_LOCATION}/tasks/permissions.sh

# SSL certificates
source ${SCRIPTS_LOCATION}/tasks/certs.sh

# Init GitHub company repository
source ${SCRIPTS_LOCATION}/tasks/github.sh

# Set up virtual hosts
source ${SCRIPTS_LOCATION}/tasks/vhosts.sh
