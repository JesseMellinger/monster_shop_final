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
      @discount_1 = @merchant_1.discounts.create!(item_threshold: 20, value: 15.0)
      @discount_2 = @merchant_1.discounts.create!(item_threshold: 10, value: 10.0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can edit discount for my merchant' do
      visit edit_discount_path(@discount_1.id)

      fill_in 'Item threshold', with: 30

      click_button("Update Discount")

      @discount_1.reload

      expect(@discount_1.item_threshold).to eq(30)
      expect(@discount_1.value).to eq(15.0)
      expect(page).to have_content("Discount updated!")
      expect(current_path).to eq('/merchant')
    end

    it 'I receive an error message if I input a data type other than an integer into item threshold' do
      visit edit_discount_path(@discount_1.id)

      fill_in 'Item threshold', with: 30.4

      click_button("Update Discount")

      @discount_1.reload

      expect(page).to have_content("Item threshold must be an integer")

      fill_in 'Item threshold', with: 'thirty'

      click_button("Update Discount")

      @discount_1.reload

      expect(page).to have_content("Item threshold is not a number")

      expect(current_path).to eq(edit_discount_path(@discount_1.id))

      expect(@discount_1.item_threshold).to eq(20)
    end

    it 'I receive an error message when either field is left blank or when text is given for value field' do
      visit edit_discount_path(@discount_1.id)

      fill_in 'Item threshold', with: 30
      fill_in 'Value', with: ''

      click_button("Update Discount")

      @discount_1.reload

      expect(page).to have_content("Value can't be blank and Value is not a number")

      expect(current_path).to eq(edit_discount_path(@discount_1.id))

      fill_in 'Item threshold', with: ''
      fill_in 'Value', with: 15

      click_button("Update Discount")

      @discount_1.reload

      expect(page).to have_content("Item threshold can't be blank and Item threshold is not a number")

      fill_in 'Item threshold', with: 30
      fill_in 'Value', with: 'fifteen'

      click_button("Update Discount")

      @discount_1.reload

      expect(page).to have_content("Value is not a number")
    end
  end
end
