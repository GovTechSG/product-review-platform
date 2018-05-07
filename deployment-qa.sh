docker-compose -f docker-compose-prod.yml down
docker-compose -f docker-compose-prod.yml pull qa
docker-compose -f docker-compose-prod.yml pull sandbox
docker-compose -f docker-compose-prod.yml up -d --build
docker-compose -f docker-compose-prod.yml run qa rake db:migrate
docker-compose -f docker-compose-prod.yml run sandbox rake db:migrate
docker-compose -f docker-compose-prod.yml run -d --publish 3000:3000 --entrypoint "sh /app/docker-onrun.sh" sandbox
docker-compose -f docker-compose-prod.yml run -d --publish 3000:3002 --entrypoint "sh /app/docker-onrun.sh" qa
docker system prune -a -f