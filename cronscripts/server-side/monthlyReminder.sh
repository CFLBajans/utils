#!/bin/bash

# This script is for sending the mailing list the meeting reminders every second 
# Saturday and the Thursday before the next meeting (third Satureday of the month)
# Add to crontab like so: 0 0 8-14 * * [`date +"%a"`==Sun]&&/path/to/monthlyReminder.sh
# Add to crontab like so: 0 0 * * * [`date +"%a"`==Thu]&&/path/to/monthlyReminder.sh

# if Sun then run the python script, else check if the date is new date -3 days
if [[ `date +"%a"` == "Sun" ]]; then
	python /path/to/automate/sendemail.py
else
	source path/to/newDate.txt
	nextSat=$(date -d "+3 days" +"%Y%m%d")
	if [[ $nextSat == $saveDate ]]; then
		python /path/to/automate/sendemail.py
	fi
fi
