# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130723095404) do

  create_table "channels", :force => true do |t|
    t.integer  "website_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "channels", ["website_id"], :name => "index_channels_on_website_id"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "created_by_id"
    t.string   "attachment_access_token"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "clients", ["created_by_id"], :name => "index_clients_on_created_by_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "created_by_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["created_by_id"], :name => "index_projects_on_created_by_id"

  create_table "spots", :force => true do |t|
    t.integer  "website_id"
    t.integer  "channel_id"
    t.string   "name"
    t.integer  "price"
    t.text     "spec"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "unit"
    t.text     "remark"
  end

  add_index "spots", ["channel_id"], :name => "index_spots_on_channel_id"
  add_index "spots", ["website_id"], :name => "index_spots_on_website_id"

  create_table "upload_files", :force => true do |t|
    t.string   "data_file_file_name"
    t.string   "data_file_content_type"
    t.integer  "data_file_file_size"
    t.datetime "data_file_updated_at"
    t.string   "attachment_access_token"
    t.string   "meta_data"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "websites", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "attachment_access_token"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

end
