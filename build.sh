#!/bin/bash
# Build locally. Refuses to build if the style check fails.
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
./check-style.sh
source /usr/share/rvm/scripts/rvm >/dev/null 2>&1
rvm use ruby-3.3.0@jekyll >/dev/null 2>&1
rm -rf _site
BUNDLE_PATH=/home/hsshim/sing-jekyll/vendor/bundle bundle exec jekyll build --quiet
echo "built _site"
