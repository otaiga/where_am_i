class Addtimetoauths < ActiveRecord::Migration
  def up
  	 add_column :auths, :last_time, :string
  end

  def down
  	remove_column :auths, :last_time, :string
  end
end
