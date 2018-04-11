docker-compose -f docker-compose-qa.yml down
docker-compose -f docker-compose-qa.yml up --build -d
docker-compose -f docker-compose-qa.yml run backend rake db:create
docker-compose -f docker-compose-qa.yml run backend rake db:schema:load
docker-compose -f docker-compose-qa.yml run backend rake db:seed
docker-compose -f docker-compose-qa.yml run -d --publish 3000:3000 --entrypoint "sh /app/docker-onrun.sh" backend
