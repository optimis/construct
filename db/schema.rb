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

ActiveRecord::Schema.define(:version => 20110209012553) do

  create_table "branches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.string   "name"
  end

  add_index "branches", ["project_id", "name"], :name => "index_branches_on_project_id_and_name"
  add_index "branches", ["project_id"], :name => "index_branches_on_project_id"

  create_table "builds", :force => true do |t|
    t.text     "payload"
    t.string   "status"
    t.integer  "commit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "run_output",   :limit => 16777215
    t.integer  "number"
    t.text     "instructions"
    t.string   "site"
    t.text     "run_errors",   :limit => 16777215
  end

  create_table "commits", :force => true do |t|
    t.integer  "project_id"
    t.string   "sha"
    t.text     "modified"
    t.text     "added"
    t.text     "removed"
    t.datetime "timestamp"
    t.integer  "author_id"
    t.string   "url"
    t.text     "message"
    t.integer  "branch_id"
  end

  add_index "commits", ["branch_id"], :name => "index_commits_on_branch_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string "name"
    t.string "email"
    t.string "username"
  end

  create_table "projects", :force => true do |t|
    t.string  "name"
    t.text    "instructions"
    t.string  "build_directory"
    t.string  "site"
    t.string  "permalink"
    t.integer "timeout",         :default => 600
    t.string  "clone_url"
  end

  add_index "projects", ["permalink"], :name => "index_projects_on_permalink"

end
