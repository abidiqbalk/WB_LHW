class AddPhotoColumnsToPhoneEntry < ActiveRecord::Migration
 def self.up
    change_table :phone_entries do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :phone_entries, :photo
  end
end
