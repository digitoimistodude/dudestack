# General vars
ENV_FILE="${HOME}/.env_createproject"

# Ask project name
echo "${BOLDYELLOW}Project name in lowercase (without spaces or special characters):${TXTRESET} "
read -e PROJECTNAME

# Check if local .env found
if [ ! -f ${ENV_FILE} ]; then
  # Ask Credentials
  echo ""
  echo "${BOLDYELLOW}What is your MySQL root password (asked only first time):${TXTRESET} "
  read -e MYSQL_ROOT_PASSWORD

  echo ""
  echo "${BOLDYELLOW}What is the admin user you want to login to wp-admin by default (asked only first time):${TXTRESET} "
  read -e WP_ADMIN_USER

  echo ""
  echo "${BOLDYELLOW}What is the password you want to use with your wp-admin admin user by default (asked only first time):${TXTRESET} "
  read -e WP_ADMIN_USER_PASSWORD

  echo ""
  echo "${BOLDYELLOW}What is the email address you want to use with your wp-admin admin user by default (asked only first time):${TXTRESET} "
  read -e WP_ADMIN_USER_EMAIL

  # Add Credentials to .env
  touch ${ENV_FILE}
  echo "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" >> ${ENV_FILE}
  echo "WPUSERNAME=${WP_ADMIN_USER}" >> ${ENV_FILE}
  echo "ADMINLOGINPASS=${WP_ADMIN_USER_PASSWORD}" >> ${ENV_FILE}
  echo "WPEMAIL=${WP_ADMIN_USER_EMAIL}" >> ${ENV_FILE}
fi

# Do we use GitHub settings or not
if grep -q "GITHUB_COMPANY_USERNAME" ${ENV_FILE}; then
  # If found
  echo ""
else
  # If not found
  echo ""
  read -p "${BOLDYELLOW}Do you want to use automatic GitHub organisation repositories for your projects? (y/n)${TXTRESET} " yngithub
    if [ "$yngithub" = "y" ]; then

      # GitHub username
      if grep -q "GITHUB_COMPANY_USERNAME" ${ENV_FILE}; then
        # If found
        echo ""
      else
        # If not found
        echo ""
        echo "${BOLDYELLOW}GitHub company username (this is used for repo url):${TXTRESET} "
        read -e GITHUB_COMPANY_USERNAME

        # Add Credentials to .env
        echo "GITHUB_COMPANY_USERNAME=${GITHUB_COMPANY_USERNAME}" >> ${ENV_FILE}
      fi

      # GitHub access token
      if grep -q "GITHUB_ACCESS_TOKEN" ${ENV_FILE}; then
        # If found
        echo ""
      else
        # If not found
        echo ""
        echo "${BOLDYELLOW}GitHub access token (Tutorial, use Classic: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#personal-access-tokens-classic):${TXTRESET} "
        read -e GITHUB_ACCESS_TOKEN

        # Add Credentials to .env
        echo "GITHUB_ACCESS_TOKEN=${GITHUB_ACCESS_TOKEN}" >> ${ENV_FILE}
      fi
    fi
fi

# Asked vars in env
MYSQL_ROOT_PASSWORD_ENV=$(grep MYSQL_ROOT_PASSWORD $ENV_FILE | cut -d '=' -f2)
WP_ADMIN_USER_ENV=$(grep WPUSERNAME $ENV_FILE | cut -d '=' -f2)
WP_ADMIN_USER_PASSWORD_ENV=$(grep ADMINLOGINPASS $ENV_FILE | cut -d '=' -f2)
WP_ADMIN_USER_EMAIL_ENV=$(grep WPEMAIL $ENV_FILE | cut -d '=' -f2)
GITHUB_ACCESS_TOKEN_ENV=$(grep GITHUB_ACCESS_TOKEN $ENV_FILE | cut -d '=' -f2)
GITHUB_COMPANY_USERNAME_ENV=$(grep GITHUB_COMPANY_USERNAME $ENV_FILE | cut -d '=' -f2)
echo ""
