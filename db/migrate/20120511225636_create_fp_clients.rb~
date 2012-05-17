class CreateFpClients < ActiveRecord::Migration
  def change
    create_table :fp_clients do |t|
      t.references:fp_client
      t.integer:lhw_code
      t.string:name
      t.string:mobile_number
      t.string:method_used
      t.integer:average_monthly_consumption
      t.string:source
      t.string:receiving_supplies
      t.string:feedback
      t.datetime:date_of_visit
      t.timestamps
    end
  end
end
