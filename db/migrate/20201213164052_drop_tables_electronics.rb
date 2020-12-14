class DropTablesElectronics < ActiveRecord::Migration[6.0]
  def change
    drop_table :computers
    drop_table :part_categories
    drop_table :part_categories_parts
    drop_table :part_use_periods
    drop_table :parts
  end
end
