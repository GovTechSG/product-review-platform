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
if [ -z ${TEAMCITY_VERSION+x} ]; then
  JUNIT_FMT_PATH="`gem path rubocop-junit-formatter`/lib/rubocop/formatter/junit_formatter.rb"
  bundle exec rubocop -r ${JUNIT_FMT_PATH} --format RuboCop::Formatter::JUnitFormatter > tmp/test_output/rubocop.xml \
    || echo "##teamcity[buildProblem description='Rubocop has failed' identity='rubocop']"

else
  TEAMCITY_FMT_PATH="`bundle show rubocop-teamcity-formatter`/lib/rubocop/formatter/teamcity-formatter.rb"
  bundle exec rubocop -r ${TEAMCITY_FMT_PATH} --format RuboCop::Formatter::TeamCityFormatter \
    || echo "##teamcity[buildProblem description='Rubocop has failed' identity='rubocop']"
fi

set -e

echo 'TCPSocket 3310' > /etc/clamav/clamd.conf
echo "TCPAddr $(getent hosts clamd | awk '{ print $1 }')" >> /etc/clamav/clamd.conf

echo "##teamcity[progressStart 'Migrating and seeding database']"
bundle exec rails db:environment:set RAILS_ENV=test
bundle exec rake db:schema:load
echo "##teamcity[progressFinish 'Migrating and seeding database']"

RSPEC_TEAMCITY_FORMATTER="`gem path rspec-teamcity`/lib/rspec/teamcity.rb"
RSPEC_FORMATTER="p"
if [ -z ${TEAMCITY_VERSION+x} ]; then
  RSPEC_FORMATTER="p"
else
  RSPEC_FORMATTER="Spec::Runner::Formatter::TeamcityFormatter"
fi

echo "##teamcity[testSuiteStarted name='rspec']"
XVFB_WHD=${XVFB_WHD:-1920x1080x16}
xvfb-run -a -s "-screen 0 ${XVFB_WHD}" \
  bundle exec rspec --require "${RSPEC_TEAMCITY_FORMATTER}" \
  --format "${RSPEC_FORMATTER}" || echo "##teamcity[buildProblem description='Rspec tests has failed' identity='rspec']"
echo "##teamcity[testSuiteFinished name='rspec']"