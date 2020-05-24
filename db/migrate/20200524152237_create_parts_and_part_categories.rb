class CreatePartsAndPartCategories < ActiveRecord::Migration[6.0]
  def change
    
    create_table :part_categories do |t|
      t.string :name
      t.string :name_singular
      t.string :name_lowercase_plural
      t.string :description

      t.timestamps
    end

    create_table :parts do |t|
      t.string :model
      t.string :name
      t.string :part_number
      t.text :specs
      t.date :purchase_date
      t.date :disposal_date
      t.text :note

      t.timestamps
    end

    create_join_table :part_categories, :parts do |t|
      t.index :part_category_id
      t.index :part_id
    end

  end
end
