# Brazil
Brazil is a tool to track schema changes to database instances. It is implemented in Ruby on Rails and support deployment of changes to Ruby DBI supported databases (currently MySQL, Oracle and PostgreSQL).

New features or bugs can be reported to Brazil's [issue tracker](http://github.com/jbripley/brazil/issues) on github.

# Install
To setup Brazil you need to follow these steps:

1. Copy config/database.example to config/database.yml
2. Run `rake db:migrate`
3. Run `rake tmp:create`
4. Setup version control configuration in config/config.yml, by following the Version Control section.

## Requirements
Brazil requires Ruby on Rails 2.2.2, Ruby DBI, RIO and Subversion binding for Ruby. Ruby DBI DBD drivers and their dependencies are required for any deploy database you want to use.

Module sqlite3-ruby is required to use the default database configuration.

Mongrel is recommended for local development and Phusion Passenger is recommended for production deployment.

## Running
Brazil is a standard Ruby on Rails application. After following the installation steps, start it by running, for example, the server script: `./script/server`

## Schema Version Table
Brazil requires a `schema_versions` table as specified below to function correctly. If it does not exist, it will try to create it when deploying a version for the first time.

    CREATE TABLE schema_versions (
    major int NOT NULL,
    minor int NOT NULL,
    patch int NOT NULL,
    created int NOT NULL,
    description varchar(255),
    PRIMARY KEY (major, minor, patch)
    );

## Example database
You can setup a example database with some example Database Instances, Apps, Activities, Changes and Versions. This will reset the database, so please make a copy of **db/development.sqlite3** if there is something you want to keep. Run `rake brazil:reset` to setup the example db.

# Version Control
Brazil enables you to check in the generated update and rollback SQL for each Version you make. There are three configuration values in config/config.yml that need to be setup for this to work:

1. vc_type needs to be set to your version control of choice, currently only Subversion is supported, with the value set to `svn`.
2. vc_uri needs to be set your version control repository root. In the case of subversion, something like http://example.com/svn.
3. vc_dir needs to be a, writable by brazil, directory that is used to checkout working copies.

Each App created in Brazil then needs to define its own version control path, which is relative to `vc_uri`. To allow brazil to check it out and commit to it when a Version is deployed.

# Abstraction
Brazil allows for Changes to be tracked in each App by a named Activity. Changes can be executed on a designated development database instance / schema pair when created or only saved to track existing Changes.

The collected Changes to an Activity can then be turned into Versions and deployed to one or several test database instance / schema pairs. A Version can be marked as deployed when it's been confirmed to have been deployed to the production system.

## Example: App FooBar
You have an application called `FooBar` which is in the subversion module `http://example.com/svn/foobar/trunk`, that you want to do some database schema changes to.

First you need change your config.yml to contain the config value `vc_uri` set to `http://example.com/svn`. Any changes to this file requires that you restart brazil to take effect.

In brazil, create an application named `FooBar`, with the `Version Control Path` set to `/foobar/trunk`.

Since your database changes for `FooBar` are connected to a `Change Request` numbered 4711 and related to the database schema `baz`, you create a new Activity in `FooBar` called `CR4711`, which uses a `Development Database` and will update the `baz` database schema.

You can then start to enter the SQL updates, by creating new Changes in the `CR4711` Activity. Each Change should (preferably) contain one database (SQL) statement each.

When you've entered all your Changes into an Activity, you must create a version of that Activity, to be able to deploy them to your test database and later on, you production database.

# Third Party
Brazil includes the following third party libraries:

* Blueprint CSS
* jQuery, jQuery UI, jQuery Scroll Follow, jQuery Form
* Styler, Javascripter
* Crummy
* Footnotes
* Twotiny Icon Set

# Contributors
The following people have made contributions to Brazil. Please let me know if I've missed anyone.

* Conny Dahlgren
* Mattias Hising
* Christer Utterberg
* Urban Edlund

# License
Copyright (c) 2008, 2009 Joakim Bodin, MIT License.
