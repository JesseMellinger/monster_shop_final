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
      merchant = item.merchant
    # case
    # when quantity >= 20 then grand_total += (item.price * quantity) - ((item.price * quantity) * (merchant.discount.twenty_item_threshold)
    # when quantity.between?(10,19) then grand_total += (item.price * quantity) - ((item.price * quantity) * (merchant.discount.ten_item_threshold)
    # when quantity.between?(5,9) then grand_total += (item.price * quantity) - ((item.price * quantity) * (merchant.discount.five_item_threshold)
      if quantity >= 20
        grand_total += (item.price * quantity ) - ((item.price * quantity) * (merchant.discount.to_f / 100))
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
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
