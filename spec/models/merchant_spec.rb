require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it {should have_many :items}
    it {should have_many(:order_items).through(:items)}
    it {should have_many :users}
    it {should have_many :discounts}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user_1 = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
      @user_2 = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'IA', zip: 80218, email: 'megan_2@example.com', password: 'securepassword')
      @order_1 = @user_1.orders.create!
      @order_2 = @user_2.orders.create!(status: 1)
      @order_3 = @user_2.orders.create!(status: 1)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_item_2 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_item_3 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2)
      @order_item_4 = @order_2.order_items.create!(item: @ogre, price: @hippo.price, quantity: 2)
      @discount_1 = @megan.discounts.create!(item_threshold: 20, value: 15.0)
      @discount_2 = @megan.discounts.create!(item_threshold: 10, value: 10.0)
    end

    it '#item_count' do
      expect(@megan.item_count).to eq(2)
      expect(@brian.item_count).to eq(1)
      expect(@sal.item_count).to eq(0)
    end

    it '#average_item_price' do
      expect(@megan.average_item_price.round(2)).to eq(35.13)
      expect(@brian.average_item_price.round(2)).to eq(50.00)
    end

    it '#distinct_cities' do
      expect(@megan.distinct_cities).to eq(['Denver, CO', 'Denver, IA'])
    end

    it '#pending_orders' do
      expect(@megan.pending_orders).to eq([@order_1])
    end

    it '#order_items_by_order' do
      expect(@megan.order_items_by_order(@order_1.id)).to eq([@order_item_1])
    end

    it '#find_max_discount' do
      expect(@megan.find_max_discount(20).first).to eq(@discount_1)
      expect(@megan.find_max_discount(15).first).to eq(@discount_2)
      expect(@megan.find_max_discount(9)).to eq([])
    end

    it '#items_with_placeholder_images'do
      @giant.update!(image: "https://image.shutterstock.com/z/stock-photo-hand-drawing-cartoon-character-big-man-showing-double-thumb-up-1138960457.jpg")
      @giant.reload

      expect(@megan.items_with_placeholder_images).to eq([@ogre])
    end

    it '#count_of_unfulfilled' do
      expect(@megan.count_of_unfulfilled).to eq(3)

      order_4 = @user_1.orders.create!
      order_item_5 = order_4.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)

      expect(@megan.count_of_unfulfilled).to eq(4)
    end

    it '#revenue_for_unfulfilled' do
      expect(@megan.revenue_for_unfulfilled).to eq(240.5)

      order_4 = @user_1.orders.create!
      order_item_5 = order_4.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)

      expect(@megan.revenue_for_unfulfilled).to eq(281)
    end

    it '#item_quantity_exceeds_inventory?' do
      @order_item_1.update(quantity: 6)
      @order_item_1.reload

      expect(@megan.item_quantity_exceeds_inventory?(@order_1)).to eq(true)

      @order_item_1.update(quantity: 5)
      @order_item_1.reload

      expect(@megan.item_quantity_exceeds_inventory?(@order_1)).to eq(false)
    end

    it '#get_items' do
      expected = [@ogre, @giant]

      expect(@megan.get_items).to eq(expected)
    end

    it '#get_discounts' do
      expected = [@discount_1, @discount_2]

      expect(@megan.get_discounts).to eq(expected)
    end
  end
end
