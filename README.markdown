# Brazil
Brazil is a tool to track changes to different database instances. It is implemented in Ruby on Rails and support deployment of changes to MySQL databases.

# Install
To setup Brazil you need to follow these steps:

1. Copy config/database.example to config/database.yml
2. Run `rake db:migrate`
3. Run `rake tmp:create`

## Requirements
Brazil requires Ruby on Rails 2.2.2, mysql-ruby and sqlite3-ruby. Mongrel is recommended for local development and Phusion Passenger is recommended for production deployment.

## Running
Brazil is a standard Ruby on Rails application, after following the installation steps, run the server script: `./script/server`

## Example database
You can setup a example database with some example Database Instances, Apps, Activities, Changes and Versions. This will reset the database, so please make a copy of **db/development.sqlite3** if there is something you want to keep. Run `rake brazil:reset` to setup the example db.

# Abstraction
Brazil allows for Changes to be tracked in each App by a named Activity. Changes can be executed on a designated development database instance / schema pair when created or only saved to track existing Changes.

The collected Changes to an Activity can then be turned into Versions and deployed to one or several test database instance / schema pairs. A Version can be marked as deployed when it's been confirmed to have been deployed to the production system.
