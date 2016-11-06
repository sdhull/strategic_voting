class AddChanceToTipToStates < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :chance_to_tip, :float
  end
end
