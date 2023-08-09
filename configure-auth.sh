#!/bin/bash

echo 'Setting up aspace-oauth plugin with omniauth_openid_connect'

PLUGINS_DIR='/archivesspace/plugins'

cd $PLUGINS_DIR
git clone --depth 1 --branch v3.2.0 https://github.com/lyrasis/aspace-oauth.git
cd /archivesspace/
echo "gem 'omniauth_openid_connect'" >> "$PLUGINS_DIR/aspace-oauth/Gemfile"

# Initializing plugin and resolving Gem conflicts
# https://github.com/umd-lib/aspace-custom/blob/main/docker_config/archivesspace/scripts/plugins.sh

OAUTH_GEMFILE_LOCK="$PLUGINS_DIR/aspace-oauth/Gemfile.lock"

# Run the first time to generate lock file
./scripts/initialize-plugin.sh aspace-oauth

sed -i 's/public_suffix (4.0.7)/public_suffix (4.0.6)/g' $OAUTH_GEMFILE_LOCK
sed -i 's/addressable (2.8.4)/addressable (2.8.0)/g' $OAUTH_GEMFILE_LOCK
sed -i 's/public_suffix (>= 2.0.2, < 6.0)/public_suffix (>= 2.0.2, < 5.0)/g' $OAUTH_GEMFILE_LOCK

# Run again to update gems
./scripts/initialize-plugin.sh aspace-oauth
