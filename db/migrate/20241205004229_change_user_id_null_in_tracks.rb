class ChangeUserIdNullInTracks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tracks, :user_id, true
  end
end
