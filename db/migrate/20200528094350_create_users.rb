class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true
      t.string :email, null: false, index: true
      t.string :password, null: false
      t.boolean :online

      t.timestamps
    end
  end
end
