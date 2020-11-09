class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
      cart.items.each do |item|
        discount = item.merchant.find_max_discount(cart.count_of(item.id)).first
        price = discount ? (item.price - (item.price * (discount.value / 100))) : item.price
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: price
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
