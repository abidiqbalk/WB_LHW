class CreateRegularTeacherAttendances < ActiveRecord::Migration
  def change
    create_table :regular_teacher_attendances do |t|

      t.timestamps
    end
  end
end
