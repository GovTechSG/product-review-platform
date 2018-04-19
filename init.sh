docker-compose -f docker-compose-prod.yml down
docker-compose -f docker-compose-prod.yml pull
docker-compose -f docker-compose-prod.yml up --build -d
docker-compose -f docker-compose-prod.yml run backend rake db:migrate
docker-compose -f docker-compose-prod.yml run -d --publish 3000:3000 --entrypoint "sh /app/docker-onrun.sh" backend

