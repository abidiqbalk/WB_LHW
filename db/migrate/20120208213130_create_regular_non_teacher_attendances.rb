class CreateRegularNonTeacherAttendances < ActiveRecord::Migration
  def change
    create_table :regular_non_teacher_attendances do |t|

      t.timestamps
    end
  end
end
