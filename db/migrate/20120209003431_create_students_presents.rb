class CreateStudentsPresents < ActiveRecord::Migration
  def change
    create_table :students_presents do |t|

      t.timestamps
    end
  end
end
