class CreateQuizFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_feedbacks do |t|
      t.string :status, limit: 255
      t.json :answer_questions
      t.references :quiz, null: false, foreign_key: { on_delete: :cascade }
      t.references :student, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
