#!/bin/bash
## /etc/icinga2/scripts/notification-telegram-host.sh
## Christopher Mueller <cm@mindengine.de>
## 2017-09-12

Usage() {
  echo "service-via-telegram-bot notification script for Icinga2 by Christopher Mueller <cm@mindengine> 2017/09/12"
  echo "This script was initially written for the use with icingaweb2 director plugin."
}

while getopts a:b:c:d:e: opt
do
  case "$opt" in
    a) HOST_ACTIVE_STATE=$OPTARG ;;
    b) HOST_LAST_STATE=$OPTARG ;;
    c) HOST_NAME=$OPTARG ;;
    d) RECIPIENT=$OPTARG ;;
    e) TELEGRAMTOKEN=$OPTARG ;;
    ?) echo "ERROR: invalid option" >&2
       exit 1 ;;
  esac
done

TELEGRAM_WEBHOOK_URL="https://api.telegram.org/bot"

#Set the message icon based on ICINGA service state
if [ "$HOST_ACTIVE_STATE" = "UP" ]
then
    ICON=$(echo -e "\U2705")
elif [ "$HOST_ACTIVE_STATE" = "DOWN" ]
then
    ICON=$(echo -e "\U1F6A8")
elif [ "$HOST_ACTIVE_STATE" = "UNREACHABLE" ]
then
    ICON=$(echo -e "\U1F480")
else
    ICON=$(echo -e "\U1F47E")
fi

#Send message to Telegram
curl --connect-timeout 30 --max-time 60 -i -X GET "${TELEGRAM_WEBHOOK_URL}${TELEGRAMTOKEN}/sendMessage?chat_id=${RECIPIENT}" --data-urlencode "text=${ICON} - ${HOST_NAME} is ${HOST_ACTIVE_STATE} was ${HOST_LAST_STATE}"