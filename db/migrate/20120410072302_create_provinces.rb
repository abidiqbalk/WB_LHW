class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
	    t.string :name
		t.string :slug
      t.timestamps
    end
  end
end
