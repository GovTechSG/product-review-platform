# Product Review Platform
Review service for bgp

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
