#!/bin/bash
# ------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# ------------------------------------------------------------
# This script is used to update the meeting time date on the
# site.
# Guidance from: 
# http://thelinuxtips.com/2012/12/06/finding-the-nth-particular-week-in-a-month-shell-script/

clear
echo "Script to update meeting date. Assumes the meeting is\
 every 3rd Saturday of the month"

# constants
DAY="1"
FREQ="3"
# ------------------------------------------------------------
# functions
USAGE()
{
	echo "------------------------------------------------------"
	echo "USAGE :: updateDate YEAR MONTH WEBSITE"
	echo "For example: "
	echo "updateDate 2017 4 ~/public_html"
	echo "The above will return the date of the 3rd Saturday in May\
 and update all html pages accordingly"
	echo "Valid values for YEAR ( 2016 to 2050 )"
    echo "Valid values for MONTH ( 1 to 12 )"
}


YearCheck()
{
    echo "$1" | grep -v "^[0-9]*$" >/dev/null 2>&1 && echo "Please enter the year" && USAGE
    if [[ ! "${1}" -le "2051" || "${1}" -eq "2016" ]]; then
        echo "Enter the correct Year [2017-2050]"
        USAGE
    fi    
}

MonthCheck()
{
    echo "$1" | grep -v "^[0-9]*$" >/dev/null 2>&1 && echo "Please enter the month" && USAGE
    if [[ ! "${1}" -le "12" || "${1}" -eq "0" ]]; then
        echo "Enter the correct Month [1-12]"
        USAGE
    fi
}

LastDigit()
{
	lastD="${1: -1}"
	
	if [[ $lastD == "1" ]]; then
        ordinalEnding="st"
    elif [[ $lastD == "2" ]]; then
    	ordinalEnding="nd"
    elif [[ $lastD == "3" ]]; then
    	ordinalEnding="rd"
    else
    	ordinalEnding="th"
    fi

    echo "$1$ordinalEnding"
}

MonthStr()
{
	if [[ $1 == "1" || $1 == "01" ]]; then
		mthStr="January"
	fi
	if [[ $1 == "2" || $1 == "02" ]]; then
		mthStr="February"
	fi
	if [[ $1 == "3" || $1 == "03" ]]; then
		mthStr="March"
	fi
	if [[ $1 == "4" || $1 == "04" ]]; then
		mthStr="April"
	fi
	if [[ $1 == "5" || $1 == "05" ]]; then
		mthStr="May"
	fi
	if [[ $1 == "6" || $1 == "06" ]]; then
		mthStr="June"
	fi
	if [[ $1 == "7" || $1 == "07" ]]; then
		mthStr="July"
	fi
	if [[ $1 == "8" || $1 == "08" ]]; then
		mthStr="August"
	fi
	if [[ $1 == "9" || $1 == "09" ]]; then
		mthStr="September"
	fi
	if [[ $1 == "10" ]]; then
		mthStr="October"
	fi
	if [[ $1 == "11" ]]; then
		mthStr="November"
	fi
	if [[ $1 == "12" ]]; then
		mthStr="December"
	fi
	echo "$mthStr"
}
# ------------------- end functions --------------------------

if [ "$#" -ne "3" ]; then
    USAGE
else
    WEBSITE=$3
    YearCheck $1
    MonthCheck $2
    NY=$1
    NM=$2
    oldDay=`cal $2 $1| tail +5|cut -c19,20| sed -n 1p`
    oldMthStr=$(MonthStr ${NM})
    oldDate="$oldMthStr $(LastDigit ${oldDay}), $NY"
    oldDay=$((oldDay-1))

    # get new date
    newMth=$((NM+1))
	newYr=$1


	if [[ $newMth == "13" ]]; then
		newYr=$((NY+1))
		newMth="1"
	fi

	newDay=`cal $newMth $newYr| tail +5|cut -c19,20| sed -n 1p`
	newMthStr=$(MonthStr ${newMth})
	newDate="$newMthStr $(LastDigit ${newDay}), $newYr"
	saveDate="$newYr$newMth$newDay"

	# change all the dates
	$PWD/updatePages.sh $WEBSITE "${oldDate}" "${newDate}"

	# add the updated files to GitHub
	cd $WEBSITE
	git add *
	git commit -m 'updated with new meeting date'
	git push origin

	# update the email reminder
	$PWD/updateMonthlyEmails.sh email-content.txt "${oldDate}" "${newDate}"

	# write new date to file 
	rm -f $PWD/nextDate.txt
	touch $PWD/nextDate.txt
	echo "saveDate="\"${saveDate}\""" > $PWD/nextDate.txt
	
	
echo "New Date: $newDate Old Date: $oldDate"
fi
