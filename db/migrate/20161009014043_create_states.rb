class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string :short_name, limit: 2
      t.string :name
      t.string :slug
      t.integer :electoral_votes

      # data to come from Princeton
      # http://election.princeton.edu/state-by-state-probabilities/
      t.integer :optimistic_win_p
      t.integer :pessimistic_win_p
      t.integer :nov_win_p
      t.integer :win_margin

      t.timestamps
    end
    add_index :states, :short_name, unique: true
  end
end
