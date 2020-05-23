class ChangeComputersDescriptionToText < ActiveRecord::Migration[6.0]
  def change
    change_column :computers, :description, :text
  end
end
