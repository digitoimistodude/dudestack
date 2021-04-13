# Check if PROJECTS_HOME directory exists
if [ ! -d ${PROJECTS_HOME} ]; then
  # But only for Mac
  if [[ $SCRIPT_LABEL =~ 'for macOS' ]]; then
    mkdir -p ${HOME}/Projects
    sudo ln -s ${HOME}/Projects ${PROJECTS_HOME}
  fi
fi

# Check if dudestack exists in the right location
if [ ! -d ${SCRIPTS_LOCATION} ]; then
    echo "${RED}dudestack not found under $PROJECTS_HOME. Please double check your installation.${TXTRESET}"
  exit
fi

echo "${YELLOW}Ensuring git is installed...${TXTRESET}"
if [ ! -f /usr/bin/git ]; then
  echo "${YELLOW}Installing git${TXTRESET}"
  sudo apt install git -y
fi

# Get latest version of dudestack if not already for some reason
cd ${SCRIPTS_LOCATION}
git pull

echo "${YELLOW}Ensuring composer is installed...${TXTRESET}"
if [ ! -f /usr/local/bin/composer ]; then
  echo "${YELLOW}Installing composer${TXTRESET}"
  cd /tmp
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  sudo mv composer.phar /usr/local/bin/composer
  sudo chmod +x /usr/local/bin/composer
fi

# Create project via roots/bedrock based command create-project from our packagist package
echo "${YELLOW}Creating project via composer create-project command...${TXTRESET}"
composer create-project -n ronilaukkarinen/dudestack $PROJECTS_HOME/${PROJECTNAME} dev-master
cd $PROJECTS_HOME/${PROJECTNAME}
composer update
