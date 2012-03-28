class CreateAssessmentDetails < ActiveRecord::Migration
  def change
    create_table :assessment_details do |t|

      t.timestamps
    end
  end
end
