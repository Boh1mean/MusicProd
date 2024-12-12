class AddCategoryToPlaylists < ActiveRecord::Migration[8.0]
  def change
    add_column :playlists, :category, :string
  end
end
