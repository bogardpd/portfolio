class CreateComputers < ActiveRecord::Migration[6.0]
  def change
    create_table :computers do |t|
      t.string :name
      t.string :slug
      t.string :model
      t.string :description
      t.string :form_factor
      t.date :purchase_date
      t.date :disposal_date

      t.timestamps
    end
  end
end
