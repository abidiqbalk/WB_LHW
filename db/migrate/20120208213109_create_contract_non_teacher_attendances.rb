class CreateContractNonTeacherAttendances < ActiveRecord::Migration
  def change
    create_table :contract_non_teacher_attendances do |t|

      t.timestamps
    end
  end
end
