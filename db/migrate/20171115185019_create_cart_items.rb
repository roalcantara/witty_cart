class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, index: true, null: false
      t.references :item, foreign_key: { to_table: :products }, index: true, null: false
      t.integer :quantity, null: false
      t.monetize :unit_price, null: false
      t.monetize :total_price, null: false
      t.timestamps
    end
  end
end
