#!/bin/bash

sudo curl -o splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm https://splunk:G3tF1l3s@awsweb1.itdns.dunkinbrands.com/files/splunk_files/splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm
sudo rpm -ivh splunkforwarder-7.0.0-c8a78efdd40f-linux-2.6-x86_64.rpm
sudo /opt/splunkforwarder/bin/splunk set deploy-poll 10.70.100.136:8089 --accept-license
sudo /opt/splunkforwarder/bin/splunk start
sudo /opt/splunkforwarder/bin/splunk enable boot-start

