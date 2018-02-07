# Product Review Platform

Status of the last build: <img src="http://teamcity:8111/app/rest/builds/buildType:(project:(id:ProductReviewPlatform)))/statusIcon.svg"/>

[![Build status](https://teamcity.jetbrains.com/guestAuth/app/rest/builds/buildType:(project:(id:ProductReviewPlatform)))/statusIcon.svg)](https://teamcity.jetbrains.com/viewType.html?buildTypeId=TeamCityPluginsByJetBrains_TeamcityGoogleTagManagerPlugin_Build)

# Setup
Create config/application.yml and add:
```yml
SECRET_KEY_BASE: 
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
