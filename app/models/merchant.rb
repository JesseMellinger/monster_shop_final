class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :order_items, through: :items
  has_many :orders, through: :order_items
  has_many :users
  has_many :discounts

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    orders.joins('JOIN users ON orders.user_id = users.id')
          .order('city_state')
          .distinct
          .pluck("CONCAT_WS(', ', users.city, users.state) AS city_state")
  end

  def pending_orders
    orders.where(status: 'pending')
  end

  def order_items_by_order(order_id)
    order_items.where(order_id: order_id)
  end

  def find_max_discount(quantity)
    self.discounts
        .where("item_threshold <= ?", quantity)
        .order("value DESC")
        .limit(1)
  end

  def items_with_placeholder_images
    placeholder_image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw"
    items.where("image = ?", placeholder_image)
  end

  def count_of_unfulfilled
    order_items.where("fulfilled = false").count
  end

  def revenue_for_unfulfilled
    order_items.where("fulfilled = false")
               .sum("order_items.price * order_items.quantity")
  end

  def item_quantity_exceeds_inventory?(order)
    order_items = self.order_items.where("order_id = ?", order.id)
    order_items.any? do |order_item|
      !order_item.fulfillable?
    end
  end

  def get_items
    Item.preload(:merchant).where('merchant_id = ?', self.id).to_a
  end

  def get_discounts
    Discount.preload(:merchant).where('merchant_id = ?', self.id).to_a
  end
end
