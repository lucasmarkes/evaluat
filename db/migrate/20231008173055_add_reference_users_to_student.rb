class AddReferenceUsersToStudent < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :student, null: true, foreign_key: { on_delete: :cascade }
  end
end
