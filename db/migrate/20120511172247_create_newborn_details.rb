class CreateNewbornDetails < ActiveRecord::Migration
  def change
    create_table :newborn_details do |t|
	t.references :newborn
	t.integer:lhw_code
	t.string :name
	t.string :mobile_number
	t.datetime :date_of_birth
	t.datetime :date_of_visit
	t.integer :anti_natal_care
	t.boolean :tt_vaccination
	t.string :birth_attendant
	t.string :place_of_delivery
	t.boolean :post_natal_care
	t.float :weight_of_newborn
	t.boolean :breast_feeding
	t.boolean :bcg_given
	t.datetime :bcg_date
	t.boolean :polio_status
	t.datetime :polio_date
	t.has_attached_file :photo
        t.timestamps
    end
  end
end
