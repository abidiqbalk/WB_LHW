class CreateSchoolCouncils < ActiveRecord::Migration
  def change
    create_table :school_councils do |t|
		t.references :inspection
		t.boolean :policy_recieved
		t.boolean :sc_reconstituted_per_policy
		t.boolean :sc_already_exists_per_policy
		t.string :account_number
		t.references :bank
		t.string :branch
		t.integer :balance_available
		t.integer :total_expenditure
		t.integer :present_balance
		t.integer :funds_recieved_from_government
		t.integer :funds_recieved_from_other
		t.integer :meetings_held_this_month
		t.timestamps
    end
  end
end
