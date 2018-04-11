#! /bin/sh
echo 'TCPSocket 3310' > /etc/clamav/clamd.conf
echo "TCPAddr $(getent hosts clamd | awk '{ print $1 }')" >> /etc/clamav/clamd.conf
bundle exec rails s