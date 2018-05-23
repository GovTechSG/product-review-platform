docker-compose -f docker-compose-test.yml down
docker-compose -f docker-compose-test.yml up --build -d
docker-compose -f docker-compose-test.yml run backend rake db:create
docker-compose -f docker-compose-test.yml run backend rake db:schema:load
docker-compose -f docker-compose-test.yml run --publish 3000:3000 --entrypoint "/app/docker/docker-entrypoint-test.sh" backend