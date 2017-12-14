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

ActiveRecord::Schema.define(version: 20171214050644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "number", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", default: "", null: false
    t.bigint "agency_id"
    t.bigint "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_comments_on_agency_id"
    t.index ["review_id"], name: "index_comments_on_review_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "UEN", default: "", null: false
    t.decimal "aggregate_score", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["UEN"], name: "index_companies_on_UEN", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "review_id"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id", "review_id"], name: "index_likes_on_agency_id_and_review_id", unique: true
    t.index ["agency_id"], name: "index_likes_on_agency_id"
    t.index ["review_id"], name: "index_likes_on_review_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "score", default: 0, null: false
    t.text "content", default: "", null: false
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_reviews_on_agency_id"
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_services_on_company_id"
  end

  add_foreign_key "comments", "agencies"
  add_foreign_key "comments", "reviews"
  add_foreign_key "likes", "agencies"
  add_foreign_key "likes", "reviews"
  add_foreign_key "products", "companies"
  add_foreign_key "reviews", "agencies"
  add_foreign_key "services", "companies"
end
