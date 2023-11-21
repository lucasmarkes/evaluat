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

ActiveRecord::Schema[7.1].define(version: 2023_11_05_173018) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "quiz_feedbacks", force: :cascade do |t|
    t.string "status", limit: 255
    t.json "answer_questions"
    t.bigint "quiz_id", null: false
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_feedbacks_on_quiz_id"
    t.index ["student_id"], name: "index_quiz_feedbacks_on_student_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "name", limit: 255
    t.json "questions"
    t.string "status", limit: 255
    t.bigint "school_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "result_metrics", default: []
    t.index ["school_class_id"], name: "index_quizzes_on_school_class_id"
  end

  create_table "school_class_students", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "school_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_class_id"], name: "index_school_class_students_on_school_class_id"
    t.index ["student_id"], name: "index_school_class_students_on_student_id"
  end

  create_table "school_classes", force: :cascade do |t|
    t.string "discipline_name", limit: 255
    t.string "teacher_name", limit: 255
    t.integer "shift"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "course", limit: 255
  end

  create_table "students", force: :cascade do |t|
    t.string "registration_number", limit: 255
    t.string "document_number", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.integer "role", default: 0
    t.bigint "student_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["student_id"], name: "index_users_on_student_id"
  end

  add_foreign_key "quiz_feedbacks", "quizzes", on_delete: :cascade
  add_foreign_key "quiz_feedbacks", "students", on_delete: :cascade
  add_foreign_key "quizzes", "school_classes", on_delete: :cascade
  add_foreign_key "school_class_students", "school_classes", on_delete: :cascade
  add_foreign_key "school_class_students", "students", on_delete: :cascade
  add_foreign_key "users", "students", on_delete: :cascade
end
