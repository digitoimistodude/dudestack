# We asked do we use GitHub in askvars.sh
# General vars
ENV_FILE="${HOME}/.env_createproject"

## Returns errlvl 0 if $1 is a reachable git remote url 
git-remote-url-reachable() {
  git ls-remote "$1" CHECK_GIT_REMOTE_URL_REACHABILITY >/dev/null 2>&1
}

# Check if .env  entry exists
if grep -q "GITHUB_COMPANY_USERNAME" ${ENV_FILE}; then
  echo ""
  echo "${YELLOW}Checking for a GitHub repo...${TXTRESET}"

  if git-remote-url-reachable "ssh://git@github.com/${GITHUB_COMPANY_USERNAME_ENV}/${PROJECTNAME}"; then
    echo ""
    echo "${RED}A repository already exists with this project name.${TXTRESET}"
    echo "${BOLDYELLOW}Are you sure you want to continue (and not use --existing)? (yes / no):${TXTRESET} "
    read -e CONTINUE

    if [[ CONTINUE -ne "yes" ]]; then
      echo ""
      echo "${YELLOW}Exiting, please re-run createproject with --existing !${TXTRESET}"
      echo ""
      exit;
    fi
  fi
fi
