# README

[![Semaphore Status](https://semaphoreci.com/api/v1/projects/40f62f1c-8a04-4a71-9eb7-d37735deb586/2264410/badge.svg)](https://semaphoreci.com/zonawiki/iot_controller)
[![Ruby Critic](https://img.shields.io/badge/RC%20Score-98.07-brightgreen.svg)](https://github.com/ZonaWiki/iot_controller "Rubycritic score")
[![SimpleCov](https://img.shields.io/badge/simplecov-passing-green.svg)](https://github.com/ZonaWiki/iot_controller "SimpleCov score")

# IOT-Controller

IOT-Controller is the platform in charge of manage Deliveries and Dispersions.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

  - Ruby 2.5.1
  * Using Docker for Development
  - Docker version 17.03.0-ce or higher
  - Docker Compose version 1.21.2 or higher

### Installing

A step by step series of examples that tell you how to get a development env running

  1. Set the environment variables with Figaro gem. Complete the variables preloaded in `config/application.yml`
  2. Run `sudo docker-compose run web rails db:create db:migrate` to create the database.
  3. Run `sudo docker-compose run web rails db:seed` to initialize the database.

### Running the app

  - Run app in development mode `sudo docker-compose up`
  - Run app locally but with production configuration `sudo docker-compose -f docker-compose.prod-local.yml up`
  - Run app in production mode `sudo docker-compose -f docker-compose.prod.yml -p iot_controller up`

## Test Suite

  - Run `sudo docker-compose run web rspec spec` for Ruby tests.
  - Run `sudo docker-compose run web yarn test` for Javascript tests.
  - Run `sudo docker-compose run web yarn test-watch` for run a watcher in Javascript tests.
  - Run `sudo docker-compose run web rake rswag:specs:swaggerize` for RSwag generators

### Break down into end to end tests

Follow this good practices:
  * [Better Specs](http://www.betterspecs.org/)
  * [Basics](https://medium.com/devnetwork/step-by-step-guide-to-write-rspec-that-is-understandable-and-readable-30279b04dd43)

### CSS Style guides

This repository use [Materialize](https://materializecss.com) as style guide

## Build an image and push it to DockerHub
  - `sudo docker build -t zonawik1/iot_controller:version .`
  - `sudo docker push zonawik1/iot_controller:version`

## Flush Redis DB
  * This command should be used carefully; it will delete the entire Redis DB.
  - Run in rails console `Sidekiq.redis { |r| puts r.flushall }`

## Deployment instructions
This repository use [Capistrano](https://capistranorb.com/) gem for deployment. Please read the documentation first.
  - Run `script/up` to deploy the app to AWS.

## Built With

* [Rails](https://github.com/rails/rails) - Framework used
* [Sidekiq](https://github.com/mperham/sidekiq) - Enqueue jobs

## Contributing

This is a private repository.

## Authors

* **Nathaly Villamor** - *Development Lead at ProCibernética* - [Nathaly](https://github.com/Jinara)
* **William Calderon** - *Full stack developer at ProCibernética* - [William](https://github.com/wecalderonc)
* **Daniela Patiño** - *Full stack developer at ProCibernética* - [Daniela](https://github.com/)

See also the list of [contributors](https://github.com/ZonaWiki/iot_controller/graphs/contributors) who participated in this project.

## Acknowledgments
