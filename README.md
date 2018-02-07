# Product Review Platform

Status of the last build: <img src="http://teamcity:8111/app/rest/builds/buildType:(project:(id:ProductReviewPlatform)))/statusIcon.svg"/>

[![Build status](https://teamcity.jetbrains.com/guestAuth/app/rest/builds/buildType:(project:(id:ProductReviewPlatform)))/statusIcon.svg)](https://teamcity.jetbrains.com/viewType.html?buildTypeId=TeamCityPluginsByJetBrains_TeamcityGoogleTagManagerPlugin_Build)

# Setup
For docker using docker-compose
  To spin the container up
    docker-compose up --build -d

  To start the services
    docker-compose run -d --publish 3000:3000  backend bundle exec rails s
    docker-compose run backend rake db:create
    docker-compose run backend rake db:schema:load

  To run rspec or rails console
    docker-compose run backend rspec
    docker-compose run backend rails c


```

Install gems, db & start.
```sh
bundle
bin/rails db:migrate RAILS_ENV=development
rails s
```

# Stack
Ruby: 2.3.5
Rails: 5.1.4
Database: Postgresql 10
