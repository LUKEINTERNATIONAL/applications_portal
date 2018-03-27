class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string :application_name
      t.string :url
      t.string :icon_link
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
