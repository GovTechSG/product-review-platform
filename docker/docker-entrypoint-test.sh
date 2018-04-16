#!/bin/bash
set -euo pipefail
BASEDIR=`dirname "$(readlink -f "$0")"`

if [ -z "${1:-}" ]; then
  echo "Running tests"
else
  exec "$@"
fi

mkdir -p tmp/test_output

echo "Running rubocop"
TEAMCITY_FMT_PATH="`bundle show rubocop-teamcity-formatter`/lib/rubocop/formatter/teamcity-formatter.rb"
bundle exec rubocop -r ${TEAMCITY_FMT_PATH} --format RuboCop::Formatter::TeamCityFormatter \
  || echo "##teamcity[buildProblem description='Rubocop has failed' identity='rubocop']"

set -e

echo 'TCPSocket 3310' > /etc/clamav/clamd.conf
echo "TCPAddr $(getent hosts clamd | awk '{ print $1 }')" >> /etc/clamav/clamd.conf

echo "##teamcity[progressStart 'Migrating and seeding database']"
bundle exec rails db:environment:set RAILS_ENV=test
bundle exec rake db:schema:load
echo "##teamcity[progressFinish 'Migrating and seeding database']"

RSPEC_TEAMCITY_FORMATTER="`bundle show rspec-teamcity`/lib/rspec/teamcity.rb"
RSPEC_FORMATTER="Spec::Runner::Formatter::TeamcityFormatter"

echo "##teamcity[testSuiteStarted name='rspec']"
bundle exec rspec --require "${RSPEC_TEAMCITY_FORMATTER}" \
  --format "${RSPEC_FORMATTER}" || echo "##teamcity[buildProblem description='Rspec tests has failed' identity='rspec']"
echo "##teamcity[testSuiteFinished name='rspec']"