class AddSlugToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :slug, :string
  end
end
