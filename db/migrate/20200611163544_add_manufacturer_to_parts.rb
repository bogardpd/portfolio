class AddManufacturerToParts < ActiveRecord::Migration[6.0]
  def change
    add_column :parts, :manufacturer, :string
  end
end
