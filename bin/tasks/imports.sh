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
