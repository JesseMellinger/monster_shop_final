class AddDiscountToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :discount, :integer
  end
end
