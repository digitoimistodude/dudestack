echo "${YELLOW}Updating .env (credentials for database and plugins)...:${TXTRESET}"
sed -i -e "s/database_name/${PROJECTNAME}/g" .env
sed -i -e "s/database_user/root/g" .env
sed -i -e "s/database_password/${MYSQL_ROOT_PASSWORD_ENV}/g" .env
sed -i -e "s/database_host/localhost/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/http/https/g" .env
# echo '
# SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE' >> .env
# echo -e '
# IMAGIFY_API_KEY=YOUR_IMAGIFY_API_KEY_HERE' >> .env
# echo -e '
# HS_BEACON_ID=YOUR_HS_BEACON_ID_HERE' >> .env
