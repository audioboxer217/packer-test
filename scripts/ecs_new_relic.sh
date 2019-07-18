#!/bin/bash

sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install -y newrelic-infra
sudo tar -xvf /dunkin/common/nri-docker-v2.0.2-linux.tar #change it to /br instead of /dunkin  incase building BR AMI.
sudo yum install -y aws-cfn-bootstrap

