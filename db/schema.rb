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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180509141611) do

  create_table "attachment_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_attachment_files_on_user_id", using: :btree
  end

  create_table "campaign_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "campaign_id"
    t.integer  "recipient_group_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["campaign_id"], name: "index_campaign_sources_on_campaign_id", using: :btree
    t.index ["recipient_group_id"], name: "index_campaign_sources_on_recipient_group_id", using: :btree
  end

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.text     "description",        limit: 65535
    t.text     "sender_name",        limit: 65535
    t.text     "sender_email",       limit: 65535
    t.text     "sender_subject",     limit: 65535
    t.boolean  "attach_file",                      default: false
    t.datetime "date_start_at"
    t.datetime "date_end_at"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "user_id"
    t.integer  "email_template_id"
    t.integer  "site_page_id"
    t.integer  "attachment_file_id"
    t.string   "site_address"
    t.integer  "send_profile_id"
    t.integer  "status"
    t.integer  "total_target"
    t.integer  "total_completed"
    t.index ["attachment_file_id"], name: "index_campaigns_on_attachment_file_id", using: :btree
    t.index ["email_template_id"], name: "index_campaigns_on_email_template_id", using: :btree
    t.index ["site_page_id"], name: "index_campaigns_on_site_page_id", using: :btree
    t.index ["user_id"], name: "index_campaigns_on_user_id", using: :btree
  end

  create_table "email_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.string   "description"
    t.text     "content",     limit: 65535
    t.boolean  "is_private",                default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_email_templates_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text     "note",       limit: 65535
    t.boolean  "read"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "recipient_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "request_type"
    t.string   "ip_address"
    t.string   "user_agent"
    t.text     "data",         limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "recipient_id"
    t.integer  "campaign_id"
    t.integer  "response_id"
    t.index ["campaign_id"], name: "index_recipient_details_on_campaign_id", using: :btree
    t.index ["recipient_id"], name: "index_recipient_details_on_recipient_id", using: :btree
    t.index ["response_id"], name: "index_recipient_details_on_response_id", using: :btree
  end

  create_table "recipient_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "description"
    t.binary   "data",        limit: 65535
    t.string   "filename"
    t.string   "mime_type"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_recipient_groups_on_user_id", using: :btree
  end

  create_table "recipients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "full_name"
    t.string   "designation"
    t.string   "department"
    t.string   "email_to"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "recipient_group_id"
    t.index ["recipient_group_id"], name: "index_recipients_on_recipient_group_id", using: :btree
  end

  create_table "report_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "report_id"
    t.integer  "campaign_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["campaign_id"], name: "index_report_sources_on_campaign_id", using: :btree
    t.index ["report_id"], name: "index_report_sources_on_report_id", using: :btree
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "token"
    t.datetime "expired_at"
    t.integer  "status",        default: 0
    t.string   "error_message"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "campaign_id"
    t.integer  "recipient_id"
    t.index ["campaign_id"], name: "index_responses_on_campaign_id", using: :btree
    t.index ["recipient_id"], name: "index_responses_on_recipient_id", using: :btree
  end

  create_table "send_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "address"
    t.integer  "port"
    t.string   "domain"
    t.string   "user_name"
    t.string   "password"
    t.string   "authentication"
    t.boolean  "enable_starttls_auto"
    t.string   "openssl_verify_mode"
    t.boolean  "public"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "title"
  end

  create_table "site_pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "title",                                                      collation: "latin1_swedish_ci"
    t.text     "description", limit: 65535,                                  collation: "latin1_swedish_ci"
    t.binary   "content",     limit: 4294967295
    t.boolean  "is_private",                     default: true
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_site_pages_on_user_id", using: :btree
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.integer  "total"
    t.integer  "used",            default: 0, null: false
    t.date     "date_expired_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.index ["name"], name: "index_subscriptions_on_name", using: :btree
  end

  create_table "upload_screenshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "origin"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.boolean  "admin",                  default: false
    t.boolean  "is_active",              default: true
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "fullname"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "report_sources", "campaigns"
  add_foreign_key "report_sources", "reports"
end
