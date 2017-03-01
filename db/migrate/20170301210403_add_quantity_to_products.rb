class AddQuantityToProducts < ActiveRecord::Migration
  def change
    add_column :products, :quantity, :integer, defaut: 0
  end
end
