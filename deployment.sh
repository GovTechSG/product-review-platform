cd product-review-platform
git pull

docker-compose down
docker-compose up —-build -d
docker-compose run backend rake db:create
docker-compose run backend rake db:schema:load
docker-compose run backend rake db:seed
docker-compose -f docker-compose.yml run -d -—publish 3000:3000  backend bundle exec rails s
