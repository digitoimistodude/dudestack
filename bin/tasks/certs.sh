echo "${YELLOW}Ensuring mkcert is installed...${TXTRESET}"
cd "$PROJECTS_HOME/$PROJECTNAME/"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if [ ! -f /usr/local/bin/mkcert ]; then
  echo "${YELLOW}Installing mkcert${TXTRESET}"

  # Check if we're on macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install via Homebrew on macOS
    if ! command_exists brew; then
      echo "${YELLOW}Homebrew not found. Installing Homebrew...${TXTRESET}"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        echo "${RED}Failed to install Homebrew, but continuing...${TXTRESET}"
      }
    fi
    brew install mkcert || echo "${YELLOW}Failed to install mkcert via brew, but continuing...${TXTRESET}"
  else
    # Linux installation
    sudo apt update || echo "${YELLOW}Failed to update apt, but continuing...${TXTRESET}"

    if ! command_exists brew; then
      echo "${YELLOW}Installing Linuxbrew...${TXTRESET}"
      sudo apt install linuxbrew-wrapper -y || echo "${YELLOW}Failed to install linuxbrew-wrapper, but continuing...${TXTRESET}"
    fi

    brew update || echo "${YELLOW}Failed to update brew, but continuing...${TXTRESET}"
    brew install mkcert || echo "${YELLOW}Failed to install mkcert via brew, but continuing...${TXTRESET}"

    # Create symlink if it doesn't exist
    if [ ! -L /usr/local/bin/mkcert ] && [ -f /home/linuxbrew/.linuxbrew/bin/mkcert ]; then
      sudo ln -s /home/linuxbrew/.linuxbrew/bin/mkcert /usr/local/bin/mkcert || echo "${YELLOW}Failed to create symlink for mkcert, but continuing...${TXTRESET}"
      sudo chmod +x /usr/local/bin/mkcert || echo "${YELLOW}Failed to make mkcert executable, but continuing...${TXTRESET}"
    fi
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
