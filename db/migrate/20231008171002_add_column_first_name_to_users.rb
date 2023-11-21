class AddColumnFirstNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string, limit: 255
  end
end
