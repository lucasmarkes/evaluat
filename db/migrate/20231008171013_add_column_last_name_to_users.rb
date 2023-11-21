class AddColumnLastNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_name, :string, limit: 255
  end
end
