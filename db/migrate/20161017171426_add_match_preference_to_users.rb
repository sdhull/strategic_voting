class AddMatchPreferenceToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :match_preference, :json
    add_column :users, :match_strict, :boolean
  end
end
