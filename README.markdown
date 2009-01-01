# Brazil
Brazil is a tool to track schema changes to database instances. It is implemented in Ruby on Rails and support deployment of changes to Ruby DBI supported databases (MySQL, ODBC, Oracle, Postgres, SQLite).

# Install
To setup Brazil you need to follow these steps:

1. Copy config/database.example to config/database.yml
2. Run `rake db:migrate`
3. Run `rake tmp:create`

## Requirements
Brazil requires Ruby on Rails 2.2.2 and Ruby DBI. Ruby DBI DBD drivers and their dependencies are required for any deploy database you want to use.

Module sqlite3-ruby is required to use the default database configuration.

Mongrel is recommended for local development and Phusion Passenger is recommended for production deployment.

## Running
Brazil is a standard Ruby on Rails application. After following the installation steps, start it by running, for example, the server script: `./script/server`

## Current limitations
Brazil requires a version table in the format `_VERSION_SCHEMA_NAME_X_Y_Z`, to exist in any database schema that you want to deploy changes to.  

## Example database
You can setup a example database with some example Database Instances, Apps, Activities, Changes and Versions. This will reset the database, so please make a copy of **db/development.sqlite3** if there is something you want to keep. Run `rake brazil:reset` to setup the example db.

# Abstraction
Brazil allows for Changes to be tracked in each App by a named Activity. Changes can be executed on a designated development database instance / schema pair when created or only saved to track existing Changes.

The collected Changes to an Activity can then be turned into Versions and deployed to one or several test database instance / schema pairs. A Version can be marked as deployed when it's been confirmed to have been deployed to the production system.

# Third Party
Brazil uses the following third party libraries:

* Blueprint CSS
* jQuery, jQuery UI, jQuery Dimensions
* Styler, Javascripter
* Crummy
* Footnotes
* Twotiny Icon Set
* resource_controller

# Contributors
The following people have made contributions to Brazil. Please let me know if I've missed anyone.

* Conny Dahlgren
* Mattias Hising
* Christer Utterberg

# License
Copyright (c) 2008 Joakim Bodin, MIT License.
