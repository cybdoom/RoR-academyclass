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

ActiveRecord::Schema.define(:version => 20141003120410) do

  create_table "answers", :force => true do |t|
    t.integer "survey_response_id"
    t.integer "option"
    t.text    "answer"
    t.integer "survey_question_id"
  end

  create_table "banners", :force => true do |t|
    t.string  "url"
    t.string  "alt_text"
    t.string  "banner_file_name"
    t.integer "position"
    t.boolean "open_in_new_window", :default => false, :null => false
  end

  create_table "booking_amendments", :force => true do |t|
    t.integer "booking_form_id"
    t.text    "description"
  end

  create_table "booking_approvals", :force => true do |t|
    t.integer "booking_form_id"
    t.string  "po_number"
    t.string  "name"
    t.string  "company_number"
    t.string  "job_title"
    t.string  "email"
    t.string  "phone"
  end

  create_table "booking_delegates", :force => true do |t|
    t.integer "booking_form_id"
    t.string  "name"
    t.string  "course_name"
    t.string  "course_location"
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "platform_pc"
    t.decimal "price",           :precision => 8, :scale => 2
    t.string  "booking_type"
    t.string  "email"
  end

  create_table "booking_form_responses", :force => true do |t|
    t.integer "booking_form_id"
    t.text    "address"
    t.text    "delivery_address"
    t.string  "contact_name"
    t.string  "contact_phone"
    t.boolean "proof_of_id"
    t.boolean "projector"
    t.boolean "software_installed"
    t.boolean "latest_version"
    t.string  "software_details"
    t.boolean "instructor_machine"
    t.boolean "lunch_provided"
    t.text    "comments"
  end

  create_table "booking_forms", :force => true do |t|
    t.string   "contact_name"
    t.string   "email"
    t.string   "telephone"
    t.string   "company"
    t.string   "address"
    t.string   "postcode"
    t.string   "salesperson"
    t.boolean  "allow_invoice"
    t.decimal  "vat_rate",           :precision => 2, :scale => 2
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "valid_to"
    t.string   "password"
    t.string   "filemaker_code"
    t.string   "booking_type"
    t.datetime "updated_at"
    t.date     "first_payment_date"
    t.boolean  "lsm"
    t.integer  "payment_count"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "contacts", :force => true do |t|
    t.string  "name"
    t.string  "company"
    t.string  "email"
    t.string  "telephone"
    t.string  "interest"
    t.text    "comments"
    t.string  "response"
    t.boolean "newsletter"
  end

  create_table "course_booking_mappings", :force => true do |t|
    t.string  "course_name"
    t.integer "video_product_id"
    t.boolean "ignored"
  end

  create_table "course_dates", :force => true do |t|
    t.integer "location_id", :null => false
    t.integer "course_id",   :null => false
    t.date    "start_date"
    t.date    "end_date"
    t.integer "total_seats"
    t.integer "seats_sold"
    t.integer "trainer_id"
  end

  add_index "course_dates", ["course_id"], :name => "fk_course_date_ref_course"
  add_index "course_dates", ["location_id"], :name => "fk_course_date_ref_location"

  create_table "course_products", :force => true do |t|
    t.integer "course_id",  :null => false
    t.integer "product_id", :null => false
    t.integer "priority"
  end

  add_index "course_products", ["course_id", "product_id"], :name => "course_product_idx", :unique => true
  add_index "course_products", ["course_id"], :name => "course_product_course_idx"
  add_index "course_products", ["product_id"], :name => "course_product_product_idx"

  create_table "course_templates", :force => true do |t|
    t.string "name"
    t.text   "copy"
  end

  create_table "courses", :force => true do |t|
    t.text    "description"
    t.string  "level",                   :limit => 50
    t.integer "duration"
    t.string  "hours"
    t.decimal "cost",                                  :precision => 8, :scale => 2
    t.string  "name"
    t.text    "who_for"
    t.text    "assumed_knowledge"
    t.text    "you_will_learn"
    t.text    "outline"
    t.integer "level_number"
    t.boolean "publish_xml",                                                         :default => true
    t.text    "overview"
    t.integer "course_template_id"
    t.text    "what_you_get"
    t.string  "logo_file_name"
    t.string  "palette_image_file_name"
    t.string  "qa_category"
  end

  create_table "email_logs", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.string   "type",             :default => "1"
    t.string   "location"
    t.text     "enquiry"
    t.string   "phone"
    t.string   "date"
    t.boolean  "opt_in"
    t.string   "subject"
    t.integer  "sales_contact_id"
    t.integer  "course_id"
    t.string   "company"
    t.string   "interest"
    t.datetime "dispatched_at"
  end

  create_table "events", :force => true do |t|
    t.string   "code",                  :limit => 20,                                                :null => false
    t.string   "name",                                                                               :null => false
    t.text     "info"
    t.decimal  "cost",                                :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "start_date",                                                                         :null => false
    t.integer  "location_id",                                                                        :null => false
    t.string   "event_image_file_name"
    t.text     "description"
  end

  add_index "events", ["location_id"], :name => "fk_event_ref_location"

  create_table "families", :force => true do |t|
    t.string  "name"
    t.integer "position"
    t.string  "tagline"
    t.string  "slug"
    t.string  "header_image_file_name"
    t.text    "description"
    t.string  "short_name"
    t.string  "family_image_file_name"
  end

  create_table "footer_links", :force => true do |t|
    t.integer "product_id"
  end

  create_table "instructors", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "staff_type",       :limit => 1
    t.string   "avatar_file_name"
  end

  create_table "locations", :force => true do |t|
    t.string  "title",     :limit => 100,                               :null => false
    t.text    "address"
    t.string  "name",      :limit => 100,                               :null => false
    t.decimal "longitude",                :precision => 8, :scale => 6
    t.decimal "latitude",                 :precision => 8, :scale => 6
  end

  create_table "menu_groups", :force => true do |t|
    t.string  "label"
    t.string  "url"
    t.integer "menu_column"
    t.integer "sequence"
    t.integer "lock_version", :default => 0, :null => false
  end

  create_table "menu_items", :force => true do |t|
    t.integer  "menu_group_id"
    t.string   "label"
    t.string   "url"
    t.integer  "sequence"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "content"
    t.boolean  "sticky",             :default => false, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug"
    t.datetime "published_at"
  end

  add_index "news", ["published_at"], :name => "index_news_on_published_at"
  add_index "news", ["slug"], :name => "index_news_on_slug", :unique => true

  create_table "news_pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "news_pages", ["slug"], :name => "index_news_pages_on_slug", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "updated_at"
  end

  create_table "payment_responses", :force => true do |t|
    t.integer  "payable_id"
    t.integer  "transaction_id"
    t.string   "transaction_status"
    t.decimal  "auth_amount",        :precision => 8, :scale => 2
    t.string   "auth_currency"
    t.text     "raw_auth_message"
    t.string   "avs"
    t.string   "waf_merch_message"
    t.string   "authentication"
    t.string   "ip_address"
    t.string   "processed_message"
    t.boolean  "success"
    t.datetime "created_at"
    t.string   "payable_type"
  end

  create_table "product_families", :force => true do |t|
    t.integer "product_id"
    t.integer "family_id"
    t.integer "position"
  end

  add_index "product_families", ["family_id"], :name => "fk_product_families_ref_families"
  add_index "product_families", ["product_id"], :name => "fk_product_families_ref_products"

  create_table "product_parents", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.string "parent_image_file_name"
  end

  add_index "product_parents", ["name"], :name => "product_parent_name"

  create_table "products", :force => true do |t|
    t.string  "name"
    t.integer "product_parent_id"
    t.text    "description"
    t.text    "summary"
    t.string  "product_logo_file_name"
    t.string  "meta_title"
    t.text    "meta_description"
  end

  create_table "questions", :force => true do |t|
    t.string  "question"
    t.integer "question_type"
    t.string  "section"
    t.boolean "one_off"
  end

  create_table "referrers", :force => true do |t|
    t.string   "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sidebar_items", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "position",   :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "survey_interests", :force => true do |t|
    t.integer "survey_response_id"
    t.integer "survey_product_id"
  end

  create_table "survey_products", :force => true do |t|
    t.string "product_parent"
    t.string "product"
  end

  create_table "survey_questions", :force => true do |t|
    t.integer "survey_id"
    t.integer "question_id"
    t.integer "position"
  end

  create_table "survey_responses", :force => true do |t|
    t.integer "survey_id"
    t.string  "name"
    t.string  "company"
    t.text    "comments"
  end

  create_table "surveys", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "location"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "trainer"
  end

  create_table "testimonials", :force => true do |t|
    t.string  "name",                 :null => false
    t.text    "quote",                :null => false
    t.string  "company",              :null => false
    t.integer "position"
    t.string  "photo_file_name"
    t.string  "video"
    t.string  "case_study_file_name"
  end

  create_table "top_courses", :force => true do |t|
    t.string  "name"
    t.integer "course_id"
    t.integer "position"
  end

  create_table "trainers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
  end

  create_table "tweets", :force => true do |t|
    t.string   "twitter_id"
    t.string   "name"
    t.string   "content"
    t.string   "profile_image"
    t.datetime "created"
  end

  create_table "uploads", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "created_at"
  end

  create_table "user_authentications", :force => true do |t|
    t.string  "provider"
    t.string  "uid"
    t.integer "user_id"
  end

  create_table "user_video_products", :force => true do |t|
    t.integer "user_id"
    t.integer "video_product_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",          :null => false
    t.string   "crypted_password",  :null => false
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "user_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "users", ["username"], :name => "user_username"

  create_table "video_features", :force => true do |t|
    t.integer "video_id"
    t.integer "position"
  end

  create_table "video_product_members", :force => true do |t|
    t.integer "video_product_id"
    t.integer "video_id"
    t.integer "sequence"
  end

  create_table "video_products", :force => true do |t|
    t.string  "name"
    t.string  "video_icon_file_name"
    t.integer "first_video_id"
    t.string  "slug"
    t.boolean "free"
  end

  create_table "video_tag_types", :force => true do |t|
    t.string "category"
    t.string "name"
    t.string "slug"
  end

  create_table "video_tags", :force => true do |t|
    t.integer "video_tag_type_id"
    t.integer "video_id"
    t.integer "sequence"
  end

  create_table "video_views", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "video_views", ["video_id", "user_id"], :name => "index_video_views_on_video_id_and_user_id"

  create_table "videos", :force => true do |t|
    t.string  "title"
    t.string  "video_url"
    t.integer "duration"
    t.text    "description"
    t.boolean "free"
    t.string  "thumbnail"
    t.string  "image"
    t.text    "transcript"
  end

end
