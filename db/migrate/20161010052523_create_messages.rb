class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :to_id, null: false
      t.integer :from_id, null: false
      t.text :subject_line
      t.text :body

      t.timestamps
    end
  end
end
