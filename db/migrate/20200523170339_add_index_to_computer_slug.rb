class AddIndexToComputerSlug < ActiveRecord::Migration[6.0]
  def change
    add_index :computers, :slug
  end
end
