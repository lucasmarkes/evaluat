# Evalu.at

## Setup

* Ruby 3.2.2
* Postgres :elephant:
* NodeJS 16.20.2
* Yarn 1.22.19

## Development

The project requires:

* Ruby 3.2.\*
* Rails 7.1.0
* PostgreSQL

## Running

```
# After you have installed all project dependencies, run the following commands to install and configure the project.

yarn install

bundle install

# Configure your enviroment and set your postgres config

cp .env.sample .env

# Create your DB and migrate

bundle exec rake db:drop db:create db:migrate db:seed

# Running server

bundle exec rails s

# Running js and css server
yarn build:css
```

### After Running
```
Go to localhost:3000 and use this login data:
Email: adm@cesar.com
Password: 123456
```
