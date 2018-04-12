#! /bin/sh
echo 'TCPSocket 3310' > /etc/clamav/clamd.conf
echo "TCPAddr $(getent hosts clamd | awk '{ print $1 }')" >> /etc/clamav/clamd.conf
rspec || echo "##teamcity[buildProblem description='Rspec has failed' identity='rspec']"
rubocop || echo "##teamcity[buildProblem description='Rubocop has failed' identity='rubocop']"