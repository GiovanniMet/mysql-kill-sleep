#!/bin/sh
#
# Killa le connessioni con un tempo superiore a TIME che non provengono dall' IP_WHITELIST
#################
USER="admin"
PASSWORD=$(cat /etc/psa/.psa.shadow)
IP_WHITELIST="1.2.3.4"
TIME=60

#mysql -u$USER -p$PASSWORD -Ns -e "SELECT id, time, host, command FROM information_schema.processlist WHERE command = 'Sleep' ORDER BY time DESC, id;"

mysql -u$USER -p$PASSWORD -Ns -e "select concat('KILL ',id,';') from information_schema.processlist where Command = 'Sleep' and time > $TIME and host not like '$IP_WHITELIST%'" > /tmp/sleep_processes.txt

#cat /tmp/sleep_processes.txt

mysql -u$USER -p$PASSWORD -e "source /tmp/sleep_processes.txt;"
rm -f /tmp/sleep_processes.txt
