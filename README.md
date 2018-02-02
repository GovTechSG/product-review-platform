# Product Review Platform
[ ![Codeship Status for GovTechSG/product-review-platform](https://app.codeship.com/projects/44920520-e9ee-0135-9c63-46e97464ee28/status?branch=master)](https://app.codeship.com/projects/270015)
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
