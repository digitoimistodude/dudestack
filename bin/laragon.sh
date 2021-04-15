#!/bin/bash
# Project starting bash script for Laragon.

# Script specific vars
SCRIPT_LABEL='with Laragon support'
SCRIPT_VERSION='1.0.4'

# Vars needed for this file to function globally
CURRENTFILE=`basename $0`

if [ "$CURRENTFILE" = "laragon.sh" ]; then
  SCRIPTS_LOCATION="$( pwd )"
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  ORIGINAL_FILE=$( readlink $DIR/$CURRENTFILE )
  SCRIPTS_LOCATION=$( dirname $ORIGINAL_FILE )
fi

echo "-----------------------------------------------------"
echo "createproject start script ${SCRIPT_LABEL}, v${SCRIPT_VERSION}"
echo "-----------------------------------------------------"
echo ""

# Variables
PROJECTS_HOME="c:/laragon/www"
DIR_TO_FILE=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
CURRENTFILE=`basename $0`
TXTBOLD=$(tput bold)
BOLDYELLOW=${TXTBOLD}$(tput setaf 3)
BOLDGREEN=${TXTBOLD}$(tput setaf 2)
BOLDWHITE=${TXTBOLD}$(tput setaf 7)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
WHITE=$(tput setaf 7)
TXTRESET=$(tput sgr0)
YEAR=$(date +%y)
CURRENTFILE=`basename $0`

source ${SCRIPTS_LOCATION}/tasks/askvars.sh

# Create project via roots/bedrock based command create-project from our packagist package
echo "${YELLOW}Creating project via composer create-project command...${TXTRESET}"
composer create-project -n ronilaukkarinen/dudestack ${PROJECTS_HOME}/${PROJECTNAME} dev-master
cd ${PROJECTS_HOME}/${PROJECTNAME}
composer update

# Initialize database
source ${SCRIPTS_LOCATION}/tasks/initdb.sh

source ${SCRIPTS_LOCATION}/tasks/dotenv.sh

source ${SCRIPTS_LOCATION}/tasks/wp-cli.sh

source ${SCRIPTS_LOCATION}/tasks/cleanups.sh

source ${SCRIPTS_LOCATION}/tasks/github.sh

source ${SCRIPTS_LOCATION}/tasks/footer.sh
