class AddMatchToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :match, index: true, foreign_key: {to_table: :users}
  end
end
