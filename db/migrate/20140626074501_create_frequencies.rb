class CreateFrequencies < ActiveRecord::Migration
  def self.up
    create_table :frequencies do |t|
      t.integer :application
      t.string  :client

      t.timestamps
    end
  end

  def self.down
    drop_table :frequencies
  end
end
