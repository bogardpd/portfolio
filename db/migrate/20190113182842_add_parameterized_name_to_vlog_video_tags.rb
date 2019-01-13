class AddParameterizedNameToVlogVideoTags < ActiveRecord::Migration[5.2]
  def change
    add_column :vlog_video_tags, :parameterized_name, :string
    add_index :vlog_video_tags, :parameterized_name
  end
end
