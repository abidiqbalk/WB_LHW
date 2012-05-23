class CreateStudentsWithoutTextbookSets < ActiveRecord::Migration
  def change
    create_table :students_without_textbook_sets do |t|

      t.timestamps
    end
  end
end
