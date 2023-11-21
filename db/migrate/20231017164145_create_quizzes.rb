class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :name, limit: 255
      t.json :questions
      t.string :status, limit: 255
      t.references :school_class, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
