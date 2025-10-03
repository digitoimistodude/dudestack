
parse_args() {
  case "$1" in
    "--existing")

      # Script header
      source ${SCRIPTS_LOCATION}/tasks/variables.sh

      # Script header
      source ${SCRIPTS_LOCATION}/tasks/header.sh

      # We asked do we use GitHub in askvars.sh
      # General vars
      ENV_FILE="${HOME}/.env_createproject"

      # Check if local .env found
      if [ ! -f ${ENV_FILE} ]; then
        echo "${RED}No .env file found. Please run the script without --existing flag first.${TXTRESET}"
        echo ""
        exit
      fi

      # Tell the user we are using existing project
      echo "${BOLDPURPLE}--existing${BOLDWHITE} flag detected. Make sure you know what you're doing.

Documentation on what this script does:
https://app.gitbook.com/o/PedExJWZmbCiZe4gDwKC/s/VVikkYgIZ9miBzwYDCYh/project-stages/joining-the-project-later-on
      ${TXTRESET}"

      # Check if company username is set
      if grep -q "GITHUB_COMPANY_USERNAME" ${ENV_FILE}; then
        GITHUB_COMPANY_USERNAME_ENV=$(grep GITHUB_COMPANY_USERNAME $ENV_FILE | cut -d '=' -f2)

        # If found
        cd "$PROJECTS_HOME"

        # Ask the existing project name
        echo "${YELLOW}What is the name of the existing project?
(The end slug here: https://github.com/${GITHUB_COMPANY_USERNAME_ENV}/${UNDERLINEDYELLOW}your-project-name-here${YELLOW})${TXTRESET} "
        read -e PROJECTNAME

        # If empty, bail
        if [ -z "$PROJECTNAME" ]; then
          echo "${RED}No project name given. Please give the correct project name.${TXTRESET}"
          echo ""
          exit
        fi

        # If clone already exists, bail
        if [ -d "$PROJECTS_HOME/$PROJECTNAME" ]; then
          echo "${RED}Project already exists. Please give the correct project name.${TXTRESET}"
          echo ""
          exit
        fi

        # If clone command fails, bail
        if ! git clone ssh://git@github.com/${GITHUB_COMPANY_USERNAME_ENV}/${PROJECTNAME}
        then
          echo "${RED}Project does not exist? Please give the correct project name.${TXTRESET}"
          echo ""
          exit

        else
          # If clone command succeeds, continue
          cd "$PROJECTS_HOME/$PROJECTNAME"

          # Check for nvm
          if [ -f "$HOME/.nvm/nvm.sh" ]; then
            # If found
            source "$HOME/.nvm/nvm.sh"

            # Run npm install in theme directory (DEV-334: no longer using root-level gulp)
            echo "${YELLOW}Running npm install in theme directory...${TXTRESET}"
            cd "$PROJECTS_HOME/$PROJECTNAME/content/themes/$PROJECTNAME"
            npm install

            # Go back to project root
            cd "$PROJECTS_HOME/$PROJECTNAME"

          else
            echo ""
          fi

          # Add project to hosts file
          echo "${YELLOW}Updating hosts file...${TXTRESET}"
          sudo -- sh -c "echo 127.0.0.1 ${PROJECTNAME}.test >> /etc/hosts"

          # Detect if project is multisite
          IS_MULTISITE=false
          if [ -f "$PROJECTS_HOME/$PROJECTNAME/config/application.php" ]; then
            if grep -q "MULTISITE.*true" "$PROJECTS_HOME/$PROJECTNAME/config/application.php"; then
              IS_MULTISITE=true
              echo "${YELLOW}Multisite detected!${TXTRESET}"
            fi
          fi

          # Set up virtual hosts
          if [ "$IS_MULTISITE" = true ]; then
            source ${SCRIPTS_LOCATION}/tasks/vhosts-multisite.sh
          else
            source ${SCRIPTS_LOCATION}/tasks/vhosts.sh
          fi

          # Add cert with mkcert
          echo "${YELLOW}Adding certificate...${TXTRESET}"
          cd $PROJECTS_HOME/certs
          mkcert $PROJECTNAME.test

          echo "${YELLOW}Restarting nginx...${TXTRESET}"

          if [ "$SCRIPT_LABEL" == "with Pop!_OS support" ]; then
            sudo systemctl restart nginx
          else
            sudo brew services stop nginx
            sudo brew services start nginx
          fi

          # Tell to add .env
          echo "${BOLDGREEN}All done! Except...${TXTRESET}"
          echo ""
          echo "${YELLOW}Next:
1. Please add .env file to project root (from 1Password)
2. Run composer install
3. If project is work in progress, set up syncthing: https://app.gitbook.com/o/PedExJWZmbCiZe4gDwKC/s/VVikkYgIZ9miBzwYDCYh/how-tos/setting-up-syncthing-on-macos/syncing-a-folder-with-syncthing
   If the project is done and you just need to work on some updates, setup media load from production: https://app.gitbook.com/o/PedExJWZmbCiZe4gDwKC/s/VVikkYgIZ9miBzwYDCYh/project-stages/joining-the-project-later-on/set-up-media-load-from-production${TXTRESET}"
          echo ""

          echo "${YELLOW}After these tasks you can start developing at https://${PROJECTNAME}.test${TXTRESET}"
          echo ""

          exit
        fi
      else
        # If not found
        echo "${RED}No GitHub company username found. Please run the script without --existing flag first.${TXTRESET}"
        echo ""
        exit
      fi

      exit
    ;;
    *)
      export DIR_TO_FILE=$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")
    ;;
    esac
}

# Parse args
parse_args "$@"
