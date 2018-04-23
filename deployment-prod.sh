docker-compose -f docker-compose-prod.yml pull backend
docker-compose -f docker-compose-prod.yml up -d --build backend
docker-compose -f docker-compose-prod.yml run backend rake db:migrate
docker system prune -a -f