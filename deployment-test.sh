docker-compose -f docker-compose-test.yml down
docker-compose -f docker-compose-test.yml up --build -d
docker-compose -f docker-compose-test.yml run backend rake db:create
docker-compose -f docker-compose-test.yml run backend rake db:schema:load
docker-compose -f docker-compose-test.yml run -d --publish 3000:3000 --entrypoint "sh /app/docker-ontest.sh" backend