require 'rails_helper'

RSpec.describe 'as a merchant employee' do
  describe 'when I visit my discount index page' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      @discount_1 = @merchant_1.discounts.create!(item_threshold: 20, value: 15.0)
      @discount_2 = @merchant_1.discounts.create!(item_threshold: 10, value: 10.0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I see the discount(s) for my merchant displayed' do
      visit discounts_path

      within("#discount-#{@discount_1.id}") do
        expect(page).to have_content("Item Threshold: #{@discount_1.item_threshold}")
        expect(page).to have_content("Discount Value: #{@discount_1.value}")
        expect(page).to have_link("Update Discount", :href=>edit_discount_path(@discount_1.id))
        expect(page).to have_link("Delete Discount", :href=>"/discounts/#{@discount_1.id}")
      end

      within("#discount-#{@discount_2.id}") do
        expect(page).to have_content("Item Threshold: #{@discount_2.item_threshold}")
        expect(page).to have_content("Discount Value: #{@discount_2.value}")
        expect(page).to have_link("Update Discount", :href=>edit_discount_path(@discount_2.id))
        expect(page).to have_link("Delete Discount", :href=>"/discounts/#{@discount_2.id}")
      end
    end
  end
end
