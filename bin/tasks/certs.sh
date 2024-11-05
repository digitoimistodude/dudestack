echo "${YELLOW}Ensuring mkcert is installed...${TXTRESET}"
cd "$PROJECTS_HOME/$PROJECTNAME/"
if [ ! -f /usr/local/bin/mkcert ]; then
  echo "${YELLOW}Installing mkcert${TXTRESET}"

  # Check if apt update succeeds
  if ! sudo apt update; then
    echo "${RED}Failed to update apt${TXTRESET}"
    exit 1
  fi

  # Install linuxbrew-wrapper
  if ! sudo apt install linuxbrew-wrapper -y; then
    echo "${RED}Failed to install linuxbrew-wrapper${TXTRESET}"
    exit 1
  fi

  # Update brew
  if ! brew update; then
    echo "${RED}Failed to update brew${TXTRESET}"
    exit 1
  fi

  # Install mkcert
  if ! brew install mkcert; then
    echo "${RED}Failed to install mkcert${TXTRESET}"
    exit 1
  fi

  # Create symlink if it doesn't exist
  if [ ! -L /usr/local/bin/mkcert ]; then
    if ! sudo ln -s /home/linuxbrew/.linuxbrew/bin/mkcert /usr/local/bin/mkcert; then
      echo "${RED}Failed to create symlink for mkcert${TXTRESET}"
      exit 1
    fi
  fi

  # Make executable
  if ! sudo chmod +x /usr/local/bin/mkcert; then
    echo "${RED}Failed to make mkcert executable${TXTRESET}"
    exit 1
  fi
fi

echo "${YELLOW}Ensuring dhparam is generated...${TXTRESET}"
if [ ! -f /etc/ssl/certs/dhparam.pem ]; then
  echo "${YELLOW}Generating dhparam${TXTRESET}"
  sudo mkdir -p /etc/ssl/certs
  cd /etc/ssl/certs
  sudo openssl dhparam -dsaparam -out dhparam.pem 4096
fi

echo "${YELLOW}Generating HTTPS cert for project...${TXTRESET}"
mkdir -p ${PROJECTS_HOME}/certs && cd ${PROJECTS_HOME}/certs && mkcert "$PROJECTNAME.test"

echo "${YELLOW}Ensuring browsersync certs are is installed...${TXTRESET}"
if [ ! -f ${PROJECTS_HOME}/certs/localhost-key.pem ]; then
  mkdir -p ${PROJECTS_HOME}/certs && cd ${PROJECTS_HOME}/certs && mkcert localhost
fi
