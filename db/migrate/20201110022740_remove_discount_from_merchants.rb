class RemoveDiscountFromMerchants < ActiveRecord::Migration[5.2]
  def change
    remove_column :merchants, :discount, :integer
  end
end
