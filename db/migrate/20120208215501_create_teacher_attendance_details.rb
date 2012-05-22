class CreateTeacherAttendanceDetails < ActiveRecord::Migration
  def change
    create_table :teacher_attendance_details do |t|

      t.timestamps
    end
  end
end
