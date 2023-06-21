class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.integer :priority, null: false
      t.string :description, null: false
      t.string :tags, null: false
      t.string :state, null: false
      t.boolean :acceptance, null: false, default: false
      t.integer :mark, default: nil
      t.references :normal_user, null: false, foreign_key: { to_table: :users }
      t.references :executive_user, null: false, foreign_key: { to_table: :users }
      t.timestamps
      t.datetime :closed_at
    end
  end
end