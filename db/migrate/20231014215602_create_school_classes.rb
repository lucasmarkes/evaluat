class CreateSchoolClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :school_classes do |t|
      t.string :discipline_name, limit: 255
      t.string :teacher_name, limit: 255
      t.integer :shift

      t.timestamps
    end
  end
end
