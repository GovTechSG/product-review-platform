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

ActiveRecord::Schema.define(version: 2018_06_25_031048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_admin_users_on_discarded_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "agencies", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "kind", default: "", null: false
    t.string "acronym", default: "", null: false
    t.string "description", default: "", null: false
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "image", default: "", null: false
    t.index ["discarded_at"], name: "index_agencies_on_discarded_at"
    t.index ["name"], name: "index_agencies_on_name", unique: true
  end

  create_table "apps", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_apps_on_discarded_at"
    t.index ["name"], name: "index_apps_on_name", unique: true
    t.index ["reset_password_token"], name: "index_apps_on_reset_password_token", unique: true
  end

  create_table "aspect_reviews", force: :cascade do |t|
    t.bigint "aspect_id"
    t.bigint "review_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aspect_id"], name: "index_aspect_reviews_on_aspect_id"
    t.index ["discarded_at"], name: "index_aspect_reviews_on_discarded_at"
    t.index ["review_id"], name: "index_aspect_reviews_on_review_id"
  end

  create_table "aspects", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_aspects_on_discarded_at"
    t.index ["name"], name: "index_aspects_on_name", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.string "commenter_type"
    t.bigint "commenter_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["commenter_type", "commenter_id"], name: "index_comments_on_commenter_type_and_commenter_id"
    t.index ["discarded_at"], name: "index_comments_on_discarded_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "uen", default: ""
    t.string "phone_number"
    t.string "url"
    t.decimal "aggregate_score", default: "0.0", null: false
    t.integer "reviews_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", default: "", null: false
    t.datetime "discarded_at"
    t.string "image", default: "", null: false
    t.index ["discarded_at"], name: "index_companies_on_discarded_at"
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["reviews_count"], name: "index_companies_on_reviews_count"
    t.index ["uen"], name: "index_companies_on_uen", unique: true
  end

  create_table "grants", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acronym", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "agency_id"
    t.index ["agency_id"], name: "index_grants_on_agency_id"
    t.index ["discarded_at"], name: "index_grants_on_discarded_at"
    t.index ["name"], name: "index_grants_on_name", unique: true
  end

  create_table "industries", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", default: "", null: false
    t.index ["discarded_at"], name: "index_industries_on_discarded_at"
    t.index ["name"], name: "index_industries_on_name", unique: true
  end

  create_table "industry_companies", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "industry_id"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_industry_companies_on_company_id"
    t.index ["discarded_at"], name: "index_industry_companies_on_discarded_at"
    t.index ["industry_id"], name: "index_industry_companies_on_industry_id"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.string "liker_type"
    t.bigint "liker_id"
    t.index ["discarded_at"], name: "index_likes_on_discarded_at"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["liker_type", "liker_id"], name: "index_likes_on_liker_type_and_liker_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "company_id"
    t.integer "reviews_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.decimal "aggregate_score"
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["reviews_count"], name: "index_products_on_reviews_count"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "company_id"
    t.integer "reviews_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.decimal "aggregate_score"
    t.index ["company_id"], name: "index_projects_on_company_id"
    t.index ["discarded_at"], name: "index_projects_on_discarded_at"
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["reviews_count"], name: "index_projects_on_reviews_count"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "score", default: 0, null: false
    t.text "content"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.bigint "grant_id"
    t.string "reviewer_type"
    t.bigint "reviewer_id"
    t.index ["discarded_at"], name: "index_reviews_on_discarded_at"
    t.index ["grant_id"], name: "index_reviews_on_grant_id"
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
    t.index ["reviewer_type", "reviewer_id"], name: "index_reviews_on_reviewer_type_and_reviewer_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "company_id"
    t.integer "reviews_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.decimal "aggregate_score"
    t.index ["company_id"], name: "index_services_on_company_id"
    t.index ["discarded_at"], name: "index_services_on_discarded_at"
    t.index ["name"], name: "index_services_on_name", unique: true
    t.index ["reviews_count"], name: "index_services_on_reviews_count"
  end

  add_foreign_key "aspect_reviews", "aspects"
  add_foreign_key "aspect_reviews", "reviews"
  add_foreign_key "grants", "agencies"
  add_foreign_key "industry_companies", "companies"
  add_foreign_key "industry_companies", "industries"
  add_foreign_key "oauth_access_tokens", "apps", column: "resource_owner_id"
  add_foreign_key "products", "companies"
  add_foreign_key "projects", "companies"
  add_foreign_key "reviews", "grants"
  add_foreign_key "services", "companies"
end
