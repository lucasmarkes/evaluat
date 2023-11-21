class CreateSchoolClassStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :school_class_students do |t|
      t.references :student, null: false, foreign_key: { on_delete: :cascade }
      t.references :school_class, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
