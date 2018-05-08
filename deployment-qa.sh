docker-compose -f docker-compose-qa.yml down
docker-compose -f docker-compose-qa.yml pull qa
docker-compose -f docker-compose-qa.yml pull sandbox
docker-compose -f docker-compose-qa.yml up -d --build
docker-compose -f docker-compose-qa.yml run qa rake db:environment:set RAILS_ENV=qa db:schema:load db:seed DISABLE_DATABASE_ENVIRONMENT_CHECK=1
docker-compose -f docker-compose-qa.yml run sandbox db:environment:set RAILS_ENV=production rake db:migrate
docker-compose -f docker-compose-qa.yml run -d --publish 3000:3000 --entrypoint "sh /app/docker-onrun.sh" sandbox
docker-compose -f docker-compose-qa.yml run -d --publish 3002:3000 --entrypoint "sh /app/docker-onrun.sh" qa
docker system prune -a -f
