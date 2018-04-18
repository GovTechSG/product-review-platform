docker-compose -f docker-compose-prod.yml stop backend
docker-compose -f docker-compose-prod.yml rm backend
docker-compose -f docker-compose-prod.yml pull backend
docker-compose -f docker-compose-prod.yml run backend
docker-compose -f docker-compose-prod.yml run backend rake db:migrate
docker-compose -f docker-compose-prod.yml run -d --publish 3000:3000 --entrypoint "sh /app/docker-onrun.sh" backend
