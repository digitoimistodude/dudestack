echo "${YELLOW}Installing WordPress...${TXTRESET}"

# Actual install command
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp core install --url=https://${PROJECTNAME}.test --title=${PROJECTNAME} --admin_user=${WP_ADMIN_USER_ENV} --admin_password=${WP_ADMIN_USER_PASSWORD_ENV} --admin_email=${WP_ADMIN_USER_EMAIL_ENV}

# Update settings
echo "${YELLOW}Removing default WordPress posts and applying settings via WP-CLI...${TXTRESET}"
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 1 --force
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 2 --force
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update blogdescription ''
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update WPLANG 'fi'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update current_theme '$PROJECTNAME'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentytwelve
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentythirteen
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update permalink_structure '/%postname%'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update timezone_string 'Europe/Helsinki'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_pingback_flag '0'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_ping_status 'closed'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_comment_status 'closed'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update date_format 'j.n.Y'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update time_format 'H.i'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update admin_email 'koodarit@dude.fi'
cd ${PROJECTS_HOME}/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option delete new_admin_email
