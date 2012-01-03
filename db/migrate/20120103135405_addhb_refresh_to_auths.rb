class AddhbRefreshToAuths < ActiveRecord::Migration
  def change
  	add_column :auths, :hb_refresh, :string
  end
end
