# We asked do we use GitHub in askvars.sh
# Check if .env  entry exists
if grep -q "GITHUB_COMPANY_USERNAME" ${ENV_FILE}; then
  # If found
  echo ""
  echo "${YELLOW}Creating a GitHub repo...${TXTRESET}"
  curl -u '"$GITHUB_COMPANY_USERNAME_ENV"':'"$GITHUB_ACCESS_TOKEN_ENV"' https://api.github.com/orgs/YOUR_GITHUB_COMPANY_USERNAME/repos -d '{"name": "'${PROJECTNAME}'","auto_init": false,"private": true,"description": "A repository for '${PROJECTNAME}' site"}'

  echo "${YELLOW}Initializing the GitHub repo...${TXTRESET}"
  cd "$PROJECTS_HOME/$PROJECTNAME"

  # We ensured earlier in the main script that git is installed so it's safe to run these
  git init
  git remote add origin git@github.com:${GITHUB_COMPANY_USERNAME}/$PROJECTNAME.git
  git config core.fileMode false
  git add --all
  git commit -m 'First commit - project started'
  git push -u origin --all
fi
