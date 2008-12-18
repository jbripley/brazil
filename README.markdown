# Brazil
Brazil is a tool to track changes to different database instances. It is implemented in Ruby on Rails and support deployment of changes to MySQL databases.

# Install
Brazil comes installed with some example Database Instances, Apps, Activities, Changes and Versions. To start with a clean slate, run the following in the brazil directory: `rake db:reset`

## Requirements
Brazil requires Ruby on Rails 2.2.2, mysql-ruby and sqlite3-ruby. Mongrel is recommended for local development and Phusion Passenger is recommended for production deployment.

## Running
Brazil comes pre-configured to run from a local sqlite3 database located in db/development.sqlite3. So to run, just run the server script: `./script/server`

# Abstraction
Brazil allows for Changes to be tracked in each App by a named Activity. Changes can be executed on a designated development database instance / schema pair when created or only saved to track existing Changes.

The collected Changes to an Activity can then be turned into Versions and deployed to one or several test database instance / schema pairs. A Version can be marked as deployed when it's been confirmed to have been deployed to the production system.
