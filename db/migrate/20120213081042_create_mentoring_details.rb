class CreateMentoringDetails < ActiveRecord::Migration
  def change
    create_table :mentoring_details do |t|

      t.timestamps
    end
  end
end
