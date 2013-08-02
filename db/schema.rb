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

ActiveRecord::Schema.define(:version => 20130802113305) do

  create_table "channel_groups", :force => true do |t|
    t.string   "name"
    t.integer  "website_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "channel_groups", ["website_id"], :name => "index_channel_groups_on_website_id"

  create_table "channels", :force => true do |t|
    t.integer  "website_id"
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "channel_group_id"
  end

  add_index "channels", ["channel_group_id"], :name => "index_channels_on_channel_group_id"
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

  create_table "master_plan_items", :force => true do |t|
    t.integer  "spot_id"
    t.integer  "master_plan_id"
    t.decimal  "count",          :precision => 10, :scale => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "master_plan_items", ["master_plan_id"], :name => "index_master_plan_items_on_master_plan_id"
  add_index "master_plan_items", ["spot_id"], :name => "index_master_plan_items_on_spot_id"

  create_table "master_plans", :force => true do |t|
    t.integer  "project_id"
    t.integer  "created_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
  end

  add_index "master_plans", ["created_by_id"], :name => "index_master_plans_on_created_by_id"
  add_index "master_plans", ["project_id"], :name => "index_master_plans_on_project_id"

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

  create_table "spot_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "sample_file_name"
    t.string   "sample_content_type"
    t.integer  "sample_file_size"
    t.datetime "sample_updated_at"
    t.string   "attachment_access_token"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "website_id"
  end

  add_index "spot_categories", ["website_id"], :name => "index_spot_categories_on_website_id"

  create_table "spot_contracts", :force => true do |t|
    t.integer  "client_id"
    t.integer  "project_id"
    t.integer  "created_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "spot_contracts", ["client_id"], :name => "index_spot_contracts_on_client_id"
  add_index "spot_contracts", ["created_by_id"], :name => "index_spot_contracts_on_created_by_id"
  add_index "spot_contracts", ["project_id"], :name => "index_spot_contracts_on_project_id"

  create_table "spot_contracts_spots", :force => true do |t|
    t.integer  "spot_id"
    t.integer  "spot_contract_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spot_contracts_spots", ["spot_contract_id"], :name => "index_spot_contracts_spots_on_spot_contract_id"
  add_index "spot_contracts_spots", ["spot_id"], :name => "index_spot_contracts_spots_on_spot_id"

  create_table "spots", :force => true do |t|
    t.integer  "website_id"
    t.integer  "channel_id"
    t.string   "name"
    t.integer  "price"
    t.text     "spec"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "unit"
    t.text     "remark"
    t.integer  "spot_category_id"
    t.string   "unit_type"
  end

  add_index "spots", ["channel_id"], :name => "index_spots_on_channel_id"
  add_index "spots", ["spot_category_id"], :name => "index_spots_on_spot_category_id"
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
