#!/bin/bash

# This script is for updating the meeting date every third Sunday
# Add to crontab like so: 0 0 15-21 * * Sun /path/to/meetingDate.sh

todayYr=date+%Y
todayMth=date+%m
/path/to/utils/cronscripts/updateDate.sh $todayYr $todayMth /path/to/git/clone/site
