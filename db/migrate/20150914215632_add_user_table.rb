class AddUserTable < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :first_name, null: false
      u.string :last_name, null: false
      u.integer :age, null: false
      u.timestamps null: false
    end
  end
end
