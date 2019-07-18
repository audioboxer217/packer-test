#!/bin/bash

sudo yum install -y yum-utils

# Setup additional yum-repo and install the latest version of osquery
curl -L https://pkg.osquery.io/rpm/GPG | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
sudo yum-config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
sudo yum-config-manager --enable osquery-s3-rpm
sudo yum -y install osquery
 
# Download the standard OSQuery configuration files  
sudo curl -o /etc/osquery/osquery.conf https://splunk:G3tF1l3s@awsweb1.itdns.dunkinbrands.com/files/Beanstalk/osquery.conf
sudo curl -o /usr/share/osquery/packs/fim.conf https://splunk:G3tF1l3s@awsweb1.itdns.dunkinbrands.com/files/Beanstalk/fim.conf
 
# Update the standard rsyslog.conf to include OSQuery data with the correct format
curl -L https://splunk:G3tF1l3s@awsweb1.itdns.dunkinbrands.com/files/Beanstalk/append_rsyslog.txt | sudo tee -a /etc/rsyslog.conf
 
# Restart the rsyslogd
sudo service rsyslog restart
 
#  Checks the config of osquery.conf file.
sudo osqueryctl config-check

# Adding osqueryd to the startup when system reboots
sudo chkconfig osqueryd on
sudo service osqueryd start 

