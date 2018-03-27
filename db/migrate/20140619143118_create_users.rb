class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.datetime :date_created
      t.string :user_status
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
