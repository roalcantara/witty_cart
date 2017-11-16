class CreateCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :carts do |t|
      t.references :owner, foreign_key: { to_table: :users }, index: true, null: false
      t.monetize :total_price, default: 0.0
      t.timestamps
    end

    add_index :carts, [:id, :owner_id], unique: true
  end
end
