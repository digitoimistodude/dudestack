echo "${YELLOW}Installing WordPress...:${TXTRESET}"
echo "path: wp
url: https://${PROJECTNAME}.test

core install:
  admin_user: ${WP_ADMIN_USER_ENV}
  admin_password: ${WP_ADMIN_USER_PASSWORD_ENV}
  admin_email: ${WP_ADMIN_USER_EMAIL_ENV}
  title: \"${PROJECTNAME}\"" > wp-cli.yml

# Actual install command
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp core install --title=$PROJECTNAME --admin_email=${WP_ADMIN_USER_EMAIL_ENV}

# Update settings
echo "${YELLOW}Removing default WordPress posts and applying settings via WP-CLI...:${TXTRESET}"
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 1 --force
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 2 --force
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update blogdescription ''
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update WPLANG 'fi'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update current_theme '$PROJECTNAME'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentytwelve
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentythirteen
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update permalink_structure '/%postname%'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update timezone_string 'Europe/Helsinki'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_pingback_flag '0'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_ping_status 'closed'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_comment_status 'closed'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update date_format 'j.n.Y'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update time_format 'H.i'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update admin_email 'koodarit@dude.fi'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option delete new_admin_email
