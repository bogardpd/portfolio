class CreateTerminalSilhouettes < ActiveRecord::Migration
  def change
    create_table :terminal_silhouettes do |t|
      t.string :iata_code
      t.string :city

      t.timestamps null: false
    end
  end
end
