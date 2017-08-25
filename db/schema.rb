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

ActiveRecord::Schema.define(version: 20170825122544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_notification_criteria", force: :cascade do |t|
    t.string   "name",          limit: 500, null: false
    t.float    "threshold_pct"
    t.string   "type",                      null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["name"], name: "index_article_notification_criteria_on_name", unique: true, using: :btree
    t.index ["threshold_pct"], name: "index_article_notification_criteria_on_threshold_pct", unique: true, where: "((type)::text = 'DiscountPercentArticleNotificationCriterium'::text)", using: :btree
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "merchant_id",              null: false
    t.string   "sku",         limit: 100,  null: false
    t.string   "name",        limit: 500,  null: false
    t.text     "description"
    t.string   "link",        limit: 2000, null: false
    t.string   "image_link",  limit: 2000
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["merchant_id", "sku"], name: "index_articles_on_merchant_id_and_sku", unique: true, using: :btree
    t.index ["merchant_id"], name: "index_articles_on_merchant_id", using: :btree
    t.index ["name"], name: "index_articles_on_name", using: :btree
  end

  create_table "buyers", force: :cascade do |t|
    t.string   "email_address", limit: 1000
    t.string   "first_name",    limit: 500
    t.string   "last_name",     limit: 500
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["email_address"], name: "index_buyers_on_email_address", unique: true, using: :btree
  end

  create_table "crawl_histories", force: :cascade do |t|
    t.integer  "index_page_id",                       null: false
    t.integer  "status",                              null: false
    t.text     "description",                         null: false
    t.integer  "article_created_count", default: 0
    t.integer  "article_updated_count", default: 0
    t.integer  "article_count",         default: 0
    t.integer  "article_invalid_count", default: 0
    t.float    "traffic_size_in_kb",    default: 0.0
    t.text     "response_headers"
    t.integer  "response_status"
    t.datetime "finished_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["index_page_id", "status", "finished_at"], name: "idx_crawl_histories_index_page_id_status_finished_at", order: { finished_at: :desc }, using: :btree
    t.index ["index_page_id", "status"], name: "index_crawl_histories_on_index_page_id_and_status", unique: true, where: "(status = ANY (ARRAY[0, 1]))", using: :btree
    t.index ["index_page_id"], name: "index_crawl_histories_on_index_page_id", using: :btree
  end

  create_table "crawl_histories_articles", id: false, force: :cascade do |t|
    t.integer "crawl_history_id", null: false
    t.integer "article_id",       null: false
    t.index ["article_id", "crawl_history_id"], name: "idx_crawl_histories_articles_article_id_crawl_history_id", unique: true, using: :btree
    t.index ["crawl_history_id", "article_id"], name: "idx_crawl_histories_articles_crawl_history_id_article_id", unique: true, using: :btree
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.integer  "base",       null: false
    t.datetime "timestamp",  null: false
    t.text     "rates",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timestamp"], name: "index_exchange_rates_on_timestamp", unique: true, using: :btree
  end

  create_table "extra_tariffs", force: :cascade do |t|
    t.string   "tariff_name",    limit: 500,                          null: false
    t.decimal  "rate",                       precision: 12, scale: 5, null: false
    t.integer  "rate_type",                                           null: false
    t.integer  "flow_direction",                                      null: false
    t.text     "description",                                         null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.index ["tariff_name"], name: "index_extra_tariffs_on_tariff_name", unique: true, using: :btree
  end

  create_table "index_pages", force: :cascade do |t|
    t.integer  "merchant_id",                null: false
    t.integer  "index_page_id"
    t.string   "relative_path", limit: 2000, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["index_page_id"], name: "index_index_pages_on_index_page_id", using: :btree
    t.index ["merchant_id", "relative_path"], name: "index_index_pages_on_merchant_id_and_relative_path", unique: true, using: :btree
    t.index ["merchant_id"], name: "index_index_pages_on_merchant_id", using: :btree
  end

  create_table "index_pages_articles", id: false, force: :cascade do |t|
    t.integer  "index_page_id", null: false
    t.integer  "article_id",    null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["article_id", "index_page_id"], name: "index_index_pages_articles_on_article_id_and_index_page_id", unique: true, using: :btree
    t.index ["index_page_id", "article_id"], name: "index_index_pages_articles_on_index_page_id_and_article_id", unique: true, using: :btree
  end

  create_table "merchant_metadata", force: :cascade do |t|
    t.integer  "merchant_id",                              null: false
    t.string   "domain",      limit: 2000,                 null: false
    t.string   "pager_css",   limit: 1000
    t.string   "item_css",    limit: 1000
    t.boolean  "ssl",                      default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["merchant_id"], name: "index_merchant_metadata_on_merchant_id", using: :btree
  end

  create_table "merchants", force: :cascade do |t|
    t.string   "code",       limit: 3,   null: false
    t.string   "name",       limit: 500, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["code"], name: "index_merchants_on_code", unique: true, using: :btree
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "status", limit: 20, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_article_sold_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["user_article_sold_id"], name: "index_orders_on_user_article_sold_id", using: :btree
  end

  create_table "price_histories", force: :cascade do |t|
    t.integer  "article_id",                          null: false
    t.decimal  "price",      precision: 18, scale: 5, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["article_id", "created_at"], name: "index_price_histories_on_article_id_and_created_at", order: { created_at: :desc }, using: :btree
    t.index ["article_id", "price"], name: "index_price_histories_on_article_id_and_price", using: :btree
    t.index ["article_id"], name: "index_price_histories_on_article_id", using: :btree
  end

  create_table "shipping_services", force: :cascade do |t|
    t.string   "service_name",    limit: 500,                                          null: false
    t.decimal  "rate",                        precision: 12, scale: 5,                 null: false
    t.float    "weight_in_kg",                                                         null: false
    t.integer  "arrival_in_days"
    t.boolean  "tracked",                                              default: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.index ["service_name"], name: "index_shipping_services_on_service_name", unique: true, using: :btree
  end

  create_table "site_settings", force: :cascade do |t|
    t.text "settings"
  end

  create_table "user_article_notifieds", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "article_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_user_article_notifieds_on_article_id", using: :btree
    t.index ["user_id", "article_id"], name: "index_user_article_notifieds_on_user_id_and_article_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_article_notifieds_on_user_id", using: :btree
  end

  create_table "user_article_notifieds_article_notification_criteria", id: false, force: :cascade do |t|
    t.integer  "user_article_notified_id",          null: false
    t.integer  "article_notification_criterium_id", null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["article_notification_criterium_id", "user_article_notified_id"], name: "idx_ua_notifieds_criteria_criterium_id_ua_notified_id", unique: true, using: :btree
    t.index ["user_article_notified_id", "article_notification_criterium_id"], name: "idx_ua_notifieds_criteria_ua_notified_id_criterium_id", unique: true, using: :btree
  end

  create_table "user_article_sold_statuses", force: :cascade do |t|
    t.integer  "user_article_sold_id",             null: false
    t.integer  "status",               default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["user_article_sold_id", "status"], name: "idx_user_article_sold_user_article_sold_id_status", unique: true, using: :btree
    t.index ["user_article_sold_id"], name: "index_user_article_sold_statuses_on_user_article_sold_id", using: :btree
  end

  create_table "user_article_solds", force: :cascade do |t|
    t.integer  "user_id",                                   null: false
    t.integer  "article_id",                                null: false
    t.integer  "exchange_rate_id",                          null: false
    t.integer  "price_history_id",                          null: false
    t.integer  "buyer_id"
    t.decimal  "price_sold",       precision: 18, scale: 5
    t.text     "notes"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["article_id"], name: "index_user_article_solds_on_article_id", using: :btree
    t.index ["buyer_id"], name: "index_user_article_solds_on_buyer_id", using: :btree
    t.index ["exchange_rate_id"], name: "index_user_article_solds_on_exchange_rate_id", using: :btree
    t.index ["price_history_id"], name: "index_user_article_solds_on_price_history_id", using: :btree
    t.index ["user_id", "article_id"], name: "index_user_article_solds_on_user_id_and_article_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_article_solds_on_user_id", using: :btree
  end

  create_table "user_article_solds_extra_tariffs", id: false, force: :cascade do |t|
    t.integer  "user_article_sold_id", null: false
    t.integer  "extra_tariff_id",      null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["extra_tariff_id", "user_article_sold_id"], name: "idx_ua_solds_extra_tariffs_extra_tariff_id_ua_sold_id", unique: true, using: :btree
    t.index ["user_article_sold_id", "extra_tariff_id"], name: "idx_ua_solds_extra_tariffs_ua_sold_id_extra_tariff_id", unique: true, using: :btree
  end

  create_table "user_article_solds_shipping_services", id: false, force: :cascade do |t|
    t.integer  "user_article_sold_id", null: false
    t.integer  "shipping_service_id",  null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["shipping_service_id", "user_article_sold_id"], name: "idx_ua_solds_shipping_services_shipping_service_id_ua_sold_id", unique: true, using: :btree
    t.index ["user_article_sold_id", "shipping_service_id"], name: "idx_ua_solds_shipping_services_ua_sold_id_shipping_service_id", unique: true, using: :btree
  end

  create_table "user_article_watcheds", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_user_article_watcheds_on_article_id", using: :btree
    t.index ["user_id", "article_id"], name: "index_user_article_watcheds_on_user_id_and_article_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_article_watcheds_on_user_id", using: :btree
  end

  create_table "user_article_watcheds_article_notification_criteria", id: false, force: :cascade do |t|
    t.integer  "user_article_watched_id",           null: false
    t.integer  "article_notification_criterium_id", null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["article_notification_criterium_id", "user_article_watched_id"], name: "idx_ua_watcheds_criteria_criterium_id_ua_watched_id", unique: true, using: :btree
    t.index ["user_article_watched_id", "article_notification_criterium_id"], name: "idx_ua_watcheds_criteria_ua_watched_id_criterium_id", unique: true, using: :btree
  end

  create_table "user_auth_tokens", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "token",      limit: 500, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["user_id"], name: "index_user_auth_tokens_on_user_id", using: :btree
  end

  create_table "user_metadata", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.string   "first_name", limit: 500
    t.string   "last_name",  limit: 500
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["user_id"], name: "index_user_metadata_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",      limit: 100,  null: false
    t.string   "email_address", limit: 1000, null: false
    t.string   "password_hash", limit: 500,  null: false
    t.datetime "last_seen_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "articles", "merchants"
  add_foreign_key "crawl_histories", "index_pages"
  add_foreign_key "crawl_histories_articles", "articles"
  add_foreign_key "crawl_histories_articles", "crawl_histories"
  add_foreign_key "index_pages", "merchants"
  add_foreign_key "index_pages_articles", "articles"
  add_foreign_key "index_pages_articles", "index_pages"
  add_foreign_key "merchant_metadata", "merchants"
  add_foreign_key "price_histories", "articles"
  add_foreign_key "user_article_notifieds", "articles"
  add_foreign_key "user_article_notifieds", "users"
  add_foreign_key "user_article_notifieds_article_notification_criteria", "article_notification_criteria"
  add_foreign_key "user_article_notifieds_article_notification_criteria", "user_article_notifieds"
  add_foreign_key "user_article_sold_statuses", "user_article_solds"
  add_foreign_key "user_article_solds", "articles"
  add_foreign_key "user_article_solds", "exchange_rates"
  add_foreign_key "user_article_solds", "price_histories"
  add_foreign_key "user_article_solds", "users"
  add_foreign_key "user_article_solds_extra_tariffs", "extra_tariffs"
  add_foreign_key "user_article_solds_extra_tariffs", "user_article_solds"
  add_foreign_key "user_article_solds_shipping_services", "shipping_services"
  add_foreign_key "user_article_solds_shipping_services", "user_article_solds"
  add_foreign_key "user_article_watcheds", "articles"
  add_foreign_key "user_article_watcheds", "users"
  add_foreign_key "user_article_watcheds_article_notification_criteria", "article_notification_criteria"
  add_foreign_key "user_article_watcheds_article_notification_criteria", "user_article_watcheds"
  add_foreign_key "user_auth_tokens", "users"
  add_foreign_key "user_metadata", "users"
end
