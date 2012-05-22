class CreateSurplusTextbookSets < ActiveRecord::Migration
  def change
    create_table :surplus_textbook_sets do |t|

      t.timestamps
    end
  end
end
