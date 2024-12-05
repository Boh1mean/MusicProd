class CreateTracks < ActiveRecord::Migration[8.0]
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.string :cloud_url, null: false  # Ссылка на трек в облаке
      t.integer :duration  # Продолжительность трека

      t.timestamps
    end
  end
end
