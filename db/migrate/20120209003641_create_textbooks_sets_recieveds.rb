class CreateTextbooksSetsRecieveds < ActiveRecord::Migration
  def change
    create_table :textbooks_sets_recieveds do |t|

      t.timestamps
    end
  end
end
