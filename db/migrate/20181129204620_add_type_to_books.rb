class AddTypeToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :type, :string
  end
end
