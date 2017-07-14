#!/bin/bash

# This script is for sending the mailing list the meeting reminders every second 
# Saturday and the Thursday before the next meeting (third Satureday of the month)
# Add to crontab like so: 0 0 8-14 * * [`date +"%a"`==Sun]&&/path/to/monthlyReminder.sh
# Add to crontab like so: 0 0 * * Thu /path/to/monthlyReminder.sh

thelist=""
# if Sun then run the python script, else check if the date is new date -3 days
if [[ `date +"%a"` == "Sun" ]]; then
	while read -r line || [[ -n "$line" ]]; do 
               thelist+=$line","
        done < /path/to/email-addresses.txt
        sendmail $thelist < /path/to/monthly-meeting.txt
else
	source path/to/newDate.txt
	nextSat=$(date -d "+2 days" +"%Y%m%d")
	if [[ $nextSat == $saveDate ]]; then
		while read -r line || [[ -n "$line" ]]; do 
            thelist+=$line","
	    done < /path/to/email-addresses.txt
       	/path/to/sendmail $thelist < /path/to/monthly-meeting.txt
	fi
fi
