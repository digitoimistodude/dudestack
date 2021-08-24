# We asked do we use GitHub in askvars.sh
# General vars
ENV_FILE="${HOME}/.env_createproject"

# Check if .env  entry exists
if grep -q "GITHUB_COMPANY_USERNAME" ${ENV_FILE}; then

  # Let's make sure the vars are found
  GITHUB_ACCESS_TOKEN_ENV=$(grep GITHUB_ACCESS_TOKEN $ENV_FILE | cut -d '=' -f2)
  GITHUB_COMPANY_USERNAME_ENV=$(grep GITHUB_COMPANY_USERNAME $ENV_FILE | cut -d '=' -f2)

  # If found
  echo ""
  echo "${YELLOW}Creating a GitHub repo...${TXTRESET}"

  curl -u "${GITHUB_COMPANY_USERNAME_ENV}":"${GITHUB_ACCESS_TOKEN_ENV}" https://api.github.com/orgs/"${GITHUB_COMPANY_USERNAME_ENV}"/repos -d '{"name": "'${PROJECTNAME}'","auto_init": false, "private": true, "description": "A repository for '${PROJECTNAME}' site"}'

  echo "${YELLOW}Initializing the GitHub repo...${TXTRESET}"
  cd "$PROJECTS_HOME/$PROJECTNAME"

  # We ensured earlier in the main script that git is installed so it's safe to run these
  git init
  git remote add origin git@github.com:${GITHUB_COMPANY_USERNAME_ENV}/${PROJECTNAME}.git
  git config core.fileMode false
  git add --all
  git commit -m 'First commit - project started'
  git push -u origin --all
fi
