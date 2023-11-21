class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :registration_number, limit: 255
      t.string :document_number, limit: 255

      t.timestamps
    end
  end
end
