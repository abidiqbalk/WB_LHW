class CreateSpecialTaskDetails < ActiveRecord::Migration
  def change
    create_table :special_task_details do |t|
      t.references:special_task
      t.string:dpiu_visited
      t.string:lhs_visited
      t.string:lhw_visited
      t.string:task_assigned
      t.text:report
      
      t.timestamps
    end
  end
end
