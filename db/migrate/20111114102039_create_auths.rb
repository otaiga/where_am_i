class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.string :hb_token
      t.string :bluevia_token
      t.string :bluevia_secret
      t.boolean :run_flag
      t.column :user_id, :integer, :null => false

      t.timestamps
    end
  end
end
