class CreatePhoneEntries < ActiveRecord::Migration
  def change
    create_table :phone_entries do |t|

      t.timestamps
    end
  end
end
