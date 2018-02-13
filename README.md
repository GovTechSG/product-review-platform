# Product Review Platform

<a href="https://teamcity.gahmen.tech/viewType.html?buildTypeId=ProductReviewPlatform_UnitTest&guest=1"> 
<img src="https://teamcity.gahmen.tech/app/rest/builds/buildType(id:ProductReviewPlatform_UnitTest)/statusIcon"/>
</a>


# Setup

For docker using docker-compose

Make sure you have `docker` and `docker-compose` installed.

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

To run rspec or rails console
```
docker-compose run backend rspec
docker-compose run backend rails c
```

# Stack
Ruby: 2.3.5
Rails: 5.1.4
Database: Postgresql 10
