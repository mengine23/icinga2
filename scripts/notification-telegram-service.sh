#!/bin/bash
## /etc/icinga2/scripts/notification-telegram-service.sh
## Christopher Mueller <cm@mindengine.de>
## 2017-09-12

Usage() {
  echo "service-via-telegram-bot notification script for Icinga2 by Christopher Mueller <cm@mindengine> 2017/09/12"
  echo "This script was initially written for the use with icingaweb2 director plugin."
}

while getopts a:b:c:d:e: opt
do
  case "$opt" in
    a) SERVICESTATE=$OPTARG ;;
    b) SERVICENAME=$OPTARG ;;
    c) HOSTDN=$OPTARG ;;
    d) RECIPIENT=$OPTARG ;;
    e) TELEGRAMTOKEN=$OPTARG ;;
    ?) echo "ERROR: invalid option" >&2
       exit 1 ;;
  esac
done

TELEGRAM_WEBHOOK_URL="https://api.telegram.org/bot"

#Set the message icon based on ICINGA service state
if [ "$SERVICESTATE" = "CRITICAL" ]
then
    ICON=$(echo -e "\U1F6A8")
elif [ "$SERVICESTATE" = "WARNING" ]
then
    ICON=$(echo -e "\U26A0")
elif [ "$SERVICESTATE" = "OK" ]
then
    ICON=$(echo -e "\U2705")
elif [ "$SERVICESTATE" = "UNKNOWN" ]
then
    ICON=$(echo -e "\U2753")
else
    ICON=$(echo -e "\U1F47E")
fi

#Send message to Telegram
curl --connect-timeout 30 --max-time 60 -i -X GET "${TELEGRAM_WEBHOOK_URL}${TELEGRAMTOKEN}/sendMessage?chat_id=${RECIPIENT}" --data-urlencode "text=${ICON} - ${SERVICENAME} on ${HOSTDN} is ${SERVICESTATE}"