# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090204131813) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "schema"
    t.string   "state"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "changes", :force => true do |t|
    t.string   "dba"
    t.string   "developer"
    t.string   "state"
    t.integer  "activity_id"
    t.text     "sql"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_instance_activities", :id => false, :force => true do |t|
    t.integer "db_instance_id"
    t.integer "activity_id"
  end

  create_table "db_instance_versions", :id => false, :force => true do |t|
    t.integer "db_instance_id"
    t.integer "version_id"
  end

  create_table "db_instances", :force => true do |t|
    t.string   "db_alias"
    t.string   "host"
    t.integer  "port"
    t.string   "db_env"
    t.string   "db_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.string   "state"
    t.string   "schema"
    t.string   "schema_version"
    t.string   "preparation"
    t.integer  "activity_id"
    t.text     "update_sql"
    t.text     "rollback_sql"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
