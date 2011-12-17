class CreateContactMes < ActiveRecord::Migration
  def change
    create_table :contact_mes do |t|

      t.timestamps
    end
  end
end
