# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_01_081417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "document_field_groups", force: :cascade do |t|
    t.string "name", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "document_fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "label", default: ""
    t.string "hint", default: ""
    t.integer "accessibility", null: false
    t.text "options"
    t.text "validations"
    t.integer "position"
    t.string "type"
    t.bigint "form_id"
    t.bigint "section_id"
    t.bigint "field_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["field_group_id"], name: "index_document_fields_on_field_group_id"
    t.index ["form_id"], name: "index_document_fields_on_form_id"
    t.index ["section_id"], name: "index_document_fields_on_section_id"
  end

  create_table "document_forms", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "description"
    t.string "type", null: false
    t.string "code"
    t.string "documentable_type"
    t.bigint "documentable_id"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachable_type", "attachable_id"], name: "index_document_forms_on_attachable"
    t.index ["documentable_type", "documentable_id"], name: "index_document_forms_on_documentable"
    t.index ["type"], name: "index_document_forms_on_type"
  end

  create_table "document_sections", force: :cascade do |t|
    t.string "title", default: ""
    t.text "description"
    t.boolean "headless", default: false, null: false
    t.bigint "form_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["form_id"], name: "index_document_sections_on_form_id"
  end

  create_table "support_uploads", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "file_data"
    t.text "metadata"
    t.integer "order"
    t.boolean "processing"
    t.string "uploadable_type"
    t.bigint "uploadable_id"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uploadable_type", "uploadable_id"], name: "index_support_uploads_on_uploadable"
  end

end
