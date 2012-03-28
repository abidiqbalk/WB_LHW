class CreateFtFunds < ActiveRecord::Migration
  def change
    create_table :ft_funds do |t|
		t.references :inspection
		t.string :account_number
		t.references :bank
		t.string :branch
		t.integer :balance_available
		t.integer :total_expenditure
		t.integer :present_balance
		t.integer :funds_recieved_from_government
		t.integer :funds_recieved_from_other
		t.timestamps
    end
  end
end
