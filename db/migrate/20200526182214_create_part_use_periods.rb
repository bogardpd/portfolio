class CreatePartUsePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :part_use_periods do |t|
      t.references :part, foreign_key: true
      t.references :computer, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
