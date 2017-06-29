#!/bin/bash

# This script is for updating the git repo
# Add to crontab like so: 0 * * * * gitupdate.sh

cd /path/to/git/clone
git pull -f
cp -rf /path/to/git/clone/* /path/to/public_html