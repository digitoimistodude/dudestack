echo "${BOLDYELLOW}Project name in lowercase (without spaces or special characters):${TXTRESET} "
read -e PROJECTNAME

# Check if local .env found
if [ ! -f ~/.env_createproject ]; then
  # Ask Credentials
  echo "${BOLDYELLOW}What is your MySQL root password (asked only first time):${TXTRESET} "
  read -e MYSQL_ROOT_PASSWORD

  echo "${BOLDYELLOW}What is the admin user you want to login to wp-admin by default (asked only first time):${TXTRESET} "
  read -e WP_ADMIN_USER

  echo "${BOLDYELLOW}What is the password you want to use with your wp-admin admin user by default (asked only first time):${TXTRESET} "
  read -e WP_ADMIN_USER_PASSWORD

  echo "${BOLDYELLOW}What is the email address you want to use with your wp-admin admin user by default (asked only first time):${TXTRESET} "
  read -e WP_ADMIN_USER_EMAIL

  # Add cREDentials to .env under HOME dir
  touch ~/.env_createproject
  echo -e "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" >> ~/.env
  echo -e "WP_ADMIN_USER=${WP_ADMIN_USER}" >> ~/.env
  echo -e "WP_ADMIN_USER_PASSWORD=${WP_ADMIN_USER_PASSWORD}" >> ~/.env
  echo -e "WP_ADMIN_USER_EMAIL=${WP_ADMIN_USER_EMAIL}" >> ~/.env
fi

# Credential vars
MYSQL_ROOT_PASSWORD_ENV=$(grep MYSQL_ROOT_PASSWORD ~/.env | cut -d '=' -f2)
WP_ADMIN_USER_ENV=$(grep WP_ADMIN_USER ~/.env | cut -d '=' -f2)
WP_ADMIN_USER_PASSWORD_ENV=$(grep WP_ADMIN_USER_PASSWORD ~/.env | cut -d '=' -f2)
WP_ADMIN_USER_EMAIL_ENV=$(grep WP_ADMIN_USER_EMAIL ~/.env | cut -d '=' -f2)
