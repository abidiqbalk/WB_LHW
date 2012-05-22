class CreateStudentsEnrolleds < ActiveRecord::Migration
  def change
    create_table :students_enrolleds do |t|

      t.timestamps
    end
  end
end
