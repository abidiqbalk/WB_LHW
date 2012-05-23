class CreateIllegalFees < ActiveRecord::Migration
  def change
    create_table :illegal_fees do |t|

      t.timestamps
    end
  end
end
