class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      item = Item.find(item_id)
      discount = item.merchant.find_max_discount(quantity).first
      if discount
        grand_total += (item.price * quantity ) - ((item.price * quantity) * (discount.value / 100))
      else
        grand_total += item.price * quantity
      end
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    discount = item.merchant.find_max_discount(@contents[item_id.to_s]).first
    if discount
      (@contents[item_id.to_s] * item.price) - ((@contents[item_id.to_s] * item.price) * (discount.value/100))
    else
      @contents[item_id.to_s] * item.price
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def items_with_discounts
    items = {}
    self.contents.each do |item_id, quantity|
      item = Item.find(item_id)
      discount = item.find_max_discount(quantity)
      items[item] = discount if item.find_max_discount(quantity)
    end
    items
  end
end
