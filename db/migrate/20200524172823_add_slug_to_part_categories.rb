class AddSlugToPartCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :part_categories, :slug, :string
    add_index :part_categories, :slug
  end
end
