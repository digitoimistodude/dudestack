echo "${YELLOW}Restarting nginx...${TXTRESET}"
sudo service nginx stop
sudo service nginx start
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"
