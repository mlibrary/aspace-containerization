#!/bin/bash

echo 'Setting up aspace-oauth plugin with omniauth_openid_connect'

PLUGINS_DIR='/archivesspace/plugins'

cd $PLUGINS_DIR
git clone --depth 1 --branch v3.2.0 https://github.com/lyrasis/aspace-oauth.git
cd /archivesspace/
cat extra_gems.txt >> "$PLUGINS_DIR/aspace-oauth/Gemfile"

# sed - i "s/gem 'addressable',   '~> 2.8'/gem 'addressable', "2.8.0"

./scripts/initialize-plugin.sh aspace-oauth

cat "$PLUGINS_DIR/aspace-oauth/Gemfile.lock"
