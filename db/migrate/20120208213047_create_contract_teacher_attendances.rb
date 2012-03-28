class CreateContractTeacherAttendances < ActiveRecord::Migration
  def change
    create_table :contract_teacher_attendances do |t|

      t.timestamps
    end
  end
end
