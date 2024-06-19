#!/bin/bash

apt-get -y update
apt-get -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# docker run hello-world



# https://docs.openwebui.com/

# If you want to disable login for a single-user setup, set WEBUI_AUTH to False. This will bypass the login page.
# WEBUI_AUTH=false

# Variable Doc:   https://docs.openwebui.com/getting-started/env-configuration#general

docker run \
    -d \
    -p 3000:8080 \
    -e OLLAMA_BASE_URL=https://DESKTOP-4UN02R1.home.boin.org:11434 \
    -e WEBUI_AUTH=false \
    -v open-webui:/app/backend/data \
    --name open-webui \
    --restart always ghcr.io/open-webui/open-webui:main 


    # --storage-opt "overlay.mount_program=/usr/bin/fuse-overlayfs"




# To update your container immediately without keeping Watchtower running continuously, use the following command. Replace open-webui with your container name if it differs.
# docker run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once open-webui

# After installation, you can access Open WebUI at http://ai.home.boin.org:3000.


# https://github.com/searxng/searxng-docker

cd /root
git clone https://github.com/searxng/searxng-docker.git
cd searxng-docker

# edit .env
echo 'SEARXNG_HOSTNAME=ai.home.boin.org' >> .env
echo 'LETSENCRYPT_EMAIL=paul@boin.org' >> .env

# generate secret key
sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" searxng/settings.yml

# edit the searxng/settings.yml file according to your need
sed -i "s|limiter: true|limiter: false|g" searxng/settings.yml

echo '
search:
  formats:
    - html
    - json
' >> searxng/settings.yml


docker compose up -d

