echo "${YELLOW}Ensuring mkcert is installed...${TXTRESET}"
cd "$PROJECTS_HOME/$PROJECTNAME/"
if [ ! -f /usr/local/bin/mkcert ]; then
  echo "${YELLOW}Installing mkcert${TXTRESET}"
  sudo apt update
  sudo apt install linuxbrew-wrapper -y
  brew update
  brew install mkcert

  # Just to make sure it's installed:
  brew install mkcert

  # Link
  sudo ln -s /home/linuxbrew/.linuxbrew/bin/mkcert /usr/local/bin/mkcert
  sudo chmod +x /usr/local/bin/mkcert
fi

echo "${YELLOW}Ensuring dhparam is generated...${TXTRESET}"
if [ ! -f /etc/ssl/certs/dhparam.pem ]; then
  echo "${YELLOW}Generating dhparam${TXTRESET}"
  sudo mkdir -p /etc/ssl/certs
  cd /etc/ssl/certs
  sudo openssl dhparam -out dhparam.pem 4096
fi

echo "${YELLOW}Generating HTTPS cert for project...${TXTRESET}"
mkdir -p /var/www/certs && cd /var/www/certs && mkcert "$PROJECTNAME.test"

echo "${YELLOW}Ensuring browsersync certs are is installed...${TXTRESET}"
if [ ! -f /var/www/certs/localhost-key.pem ]; then
  mkdir -p /var/www/certs && cd /var/www/certs && mkcert localhost
fi
