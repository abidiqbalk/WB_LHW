class CreateNonTeacherAttendanceDetails < ActiveRecord::Migration
  def change
    create_table :non_teacher_attendance_details do |t|

      t.timestamps
    end
  end
end
