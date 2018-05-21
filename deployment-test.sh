docker-compose down
docker-compose up --build -d
docker-compose run backend rake db:create
docker-compose run backend rake db:schema:load
docker-compose up -d backend