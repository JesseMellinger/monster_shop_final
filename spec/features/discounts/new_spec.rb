require 'rails_helper'

RSpec.describe 'as a merchant employee' do
  describe 'when I visit a new discount page' do
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
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can create a new discount for my merchant when item threshold and value given' do
      visit new_merchant_discount_path(@merchant_1.id)

      fill_in 'Item threshold', with: 20
      fill_in 'Value', with: 15.0

      click_button("Create Discount")

      @merchant_1.reload

      expect(@merchant_1.discounts.first.item_threshold).to eq(20)
      expect(@merchant_1.discounts.first.value).to eq(15.0)
    end

    it 'I am unable to create a new discount with either the item threshold or value fields blank' do
      visit new_merchant_discount_path(@merchant_1.id)

      fill_in 'Item threshold', with: 20

      click_button("Create Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
      expect(page).to have_content("Value can't be blank and Value is not a number")

      fill_in 'Value', with: 20

      click_button("Create Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
      expect(page).to have_content("Item threshold can't be blank and Item threshold is not a number")

      fill_in 'Item threshold', with: ''
      fill_in 'Value', with: ''

      click_button("Create Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
      expect(page).to have_content("Item threshold can't be blank, Item threshold is not a number, Value can't be blank, and Value is not a number")
    end

    it 'I receive an error message when the item threshold field is not filled with an integer and when a string is put into the value field' do
      visit new_merchant_discount_path(@merchant_1.id)

      fill_in 'Item threshold', with: 20.4
      fill_in 'Value', with: 10

      click_button("Create Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
      expect(page).to have_content("Item threshold must be an integer")

      fill_in 'Item threshold', with: 20
      fill_in 'Value', with: 'ten'

      click_button("Create Discount")

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
      expect(page).to have_content("Value is not a number")
    end
  end
end
