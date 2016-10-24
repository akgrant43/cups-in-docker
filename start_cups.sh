#!/bin/sh
set -e
set -x

if [ $(grep -ci $CUPS_USER_ADMIN /etc/shadow) -eq 0 ]; then
    useradd $CUPS_USER_ADMIN --system -G root,lpadmin --no-create-home --password $(mkpasswd $CUPS_USER_PASSWORD)
fi

service cups start
sleep 1
lpadmin -p lbp6020 -m CNCUPSLBP6020CAPTK.ppd -v ccp://localhost:59687 -E
ccpdadmin -p lbp6020 -o /dev/usb/lp1
service ccpd start
sleep 1
service cups restart

