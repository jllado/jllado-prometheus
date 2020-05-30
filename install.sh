#!/bin/sh
mkdir -p /opt/servers/prometheus/data
sudo chmod a+wrx -R /opt/servers/prometheus/data
docker-compose up -d
