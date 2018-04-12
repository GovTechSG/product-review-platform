docker-compose down
docker-compose up --build -d
docker-compose run backend rake db:create
docker-compose run backend rake db:schema:load
docker-compose run -d --publish 3000:3000 --entrypoint "sh /app/docker-ontest.sh" backend