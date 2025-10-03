echo "server {
    listen 443 ssl;
    http2 on;
    root ${PROJECTS_HOME}/$PROJECTNAME;
    index index.php;
    server_name $PROJECTNAME.test www.$PROJECTNAME.test;

    include php.conf;
    include global/wordpress.conf;

    ssl_certificate ${PROJECTS_HOME}/certs/$PROJECTNAME.test.pem;
    ssl_certificate_key ${PROJECTS_HOME}/certs/$PROJECTNAME.test-key.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security max-age=15768000;

    # Rewrites for Bedrock multisite subdomain setup
    # network and base site
    rewrite /wp-admin$ \$scheme://\$host\$uri/ last;
    rewrite ^/(wp-.*.php)$ /wp/\$1 last;
    rewrite ^/(wp-(content|admin|includes).*) /wp/\$1 last;

    # sites in subdirectories
    if (!-e \$request_filename) {
     rewrite /wp-admin$ \$scheme://\$host\$uri/ permanent;
     rewrite ^/[_0-9a-zA-Z-]+(/wp-.*) /wp\$1 last;
        rewrite ^/[_0-9a-zA-Z-]+(/.*\.php)$ /wp\$1 last;
    }
}

server {
    listen 80;
    server_name $PROJECTNAME.test;
    return 301 https://\$host\$request_uri;
}" > ~/$PROJECTNAME.test
sudo mv ~/$PROJECTNAME.test /etc/nginx/sites-available/$PROJECTNAME.test
sudo ln -s /etc/nginx/sites-available/$PROJECTNAME.test /etc/nginx/sites-enabled/$PROJECTNAME.test

# Ensure php.conf is actually there
if [ ! -f /etc/nginx/php.conf ]; then
  # Check if php7.conf found, if yes, then symlink it
  if [ -f /etc/nginx/php7.conf ]; then
    sudo ln -s /etc/nginx/php7.conf /etc/nginx/php.conf
  else
    echo "${BOLDRED}php.conf or php7.conf not found in /etc/nginx/${TXTRESET}"
    echo "${BOLDRED}Please refer to https://github.com/digitoimistodude/macos-lemp-setup for instructions.${TXTRESET}"
    exit 1
  fi
fi

echo "${BOLDGREEN}Added multisite vhost, $PROJECTNAME.test added to /etc/nginx/sites-enabled/${TXTRESET}"
