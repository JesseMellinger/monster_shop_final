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
end
