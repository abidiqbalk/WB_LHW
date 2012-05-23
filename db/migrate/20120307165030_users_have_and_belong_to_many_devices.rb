class UsersHaveAndBelongToManyDevices < ActiveRecord::Migration
  def self.up
    create_table :devices_users, :id => false do |t|
      t.references :device, :user
	  t.datetime :assigned_on
	  t.datetime :assigned_till
    end
  end
 
  def self.down
    drop_table :devices_users
  end
end
