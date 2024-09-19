#!/bin/bash

if [ -z ${CRON_EXPRESSION+x} ]; then
  exit 1
fi

echo "Configuring cron with $CRON_EXPRESSION"

(crontab -l ; echo "$CRON_EXPRESSION /usr/bin/flock -n /var/run/backup.lock bash /backup.sh") | sort - | uniq - | crontab -

crontab -l

crond -f