class CreateWhitelists < ActiveRecord::Migration
  def self.up
    create_table :whitelists do |t|
	t.column :friend, :string
	t.column :number, :string
	t.column :user_id, :integer, :null => false


      t.timestamps
    end
  end

 def self.down
 	drop_table :whitelists
    end
  end