class AddTypeToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :type, :string
  end
end
