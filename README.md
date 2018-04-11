# Product Review Platform

<a href="https://teamcity.gahmen.tech/viewType.html?buildTypeId=ProductReviewPlatform_UnitTest&guest=1"> 
<img src="https://teamcity.gahmen.tech/app/rest/builds/buildType(id:ProductReviewPlatform_UnitTest)/statusIcon"/>
</a>


# Setup

For docker using docker-compose

Make sure you have `docker` and `docker-compose` installed.

Create a file called qa.env in the root directory of the project containing these fields
```
DATABASE_TIMEOUT=
DATABASE_HOST=
DATABASE_PORT=
DATABASE_NAME=
DATABASE_SERVICE_NAME=
DATABASE_USERNAME=
DATABASE_PASSWORD=
SECRET_KEY_BASE=
RAILS_ENV=
SWAGGER_API_BASE_PATH=
ADMIN_EMAIL=
```


To spin the container up
```
docker-compose up --build -d
```

To start the services
```
docker-compose run -d --publish 3000:3000  backend bundle exec rails s
docker-compose run backend rake db:create
docker-compose run backend rake db:schema:load
```

To seed data from seed.rb 
```
docker-compose run backend rake db:seed
```

To run rspec or rails console
```
docker-compose run backend rspec
docker-compose run backend rails c
```

# Stack
Ruby: 2.3.5
Rails: 5.1.4
Database: Postgresql 10
