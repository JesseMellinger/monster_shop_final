require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  describe 'As an employee of a merchant' do
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

    it 'I can see my merchants information on the merchant dashboard' do
      visit '/merchant'

      expect(page).to have_link(@merchant_1.name)
      expect(page).to have_content(@merchant_1.address)
      expect(page).to have_content("#{@merchant_1.city} #{@merchant_1.state} #{@merchant_1.zip}")
    end

    it 'I do not have a link to edit the merchant information' do
      visit '/merchant'

      expect(page).to_not have_link('Edit')
    end

    it 'I see a list of pending orders containing my items' do
      visit '/merchant'

      within '.orders' do
        expect(page).to_not have_css("#order-#{@order_1.id}")

        within "#order-#{@order_2.id}" do
          expect(page).to have_link(@order_2.id)
          expect(page).to have_content("Potential Revenue: #{@order_2.merchant_subtotal(@merchant_1.id)}")
          expect(page).to have_content("Quantity of Items: #{@order_2.merchant_quantity(@merchant_1.id)}")
          expect(page).to have_content("Created: #{@order_2.created_at}")
        end

        within "#order-#{@order_3.id}" do
          expect(page).to have_link(@order_3.id)
          expect(page).to have_content("Potential Revenue: #{@order_3.merchant_subtotal(@merchant_1.id)}")
          expect(page).to have_content("Quantity of Items: #{@order_3.merchant_quantity(@merchant_1.id)}")
          expect(page).to have_content("Created: #{@order_3.created_at}")
        end
      end
    end

    it 'I can link to an order show page' do
      visit '/merchant'

      click_link @order_2.id

      expect(current_path).to eq("/merchant/orders/#{@order_2.id}")
    end

    it 'I see a link to create a new bulk discount and am directed to a new page to create the discount' do
      visit '/merchant'

      click_link("Create Discount")

      expect(current_path).to eq(new_discount_path)
    end

    it 'I see link to view the curent bulk discount for my merchant' do
      visit '/merchant'

      click_link("View Discount(s)")

      expect(current_path).to eq(discounts_path)
    end

    it 'I see a list of items that are using placeholder images with a message that I should find an appropriate image and each item is a link to that items edit form' do
      @giant.update!(image: "https://image.shutterstock.com/z/stock-photo-hand-drawing-cartoon-character-big-man-showing-double-thumb-up-1138960457.jpg")
      @giant.reload

      visit '/merchant'

      within(".items-placeholder-images") do
        expect(page).to have_content("Appropriate image needed for item #{@ogre.name}")
        expect(page).to_not have_content("Appropriate image needed for item #{@giant.name}")
        click_link("#{@ogre.name}")
      end

      expect(current_path).to eq(edit_merchant_item_path(@ogre.id))
    end

    it 'I see a statistic about unfulfilled items and the revenue impact' do
      visit '/merchant'

      expect(page).to have_content("You have 2 unfulfilled orders worth $140.50")

      @order_item_3.update(fulfilled: true)
      @order_item_4.update(fulfilled: true)
      @order_item_3.reload
      @order_item_4.reload

      visit '/merchant'

      expect(page).to have_content("You have 0 unfulfilled orders worth $0.00")
    end

    it 'I see a warning if an item quantity for an order exceeds current inventory count' do
      @order_item_3.update(quantity: 6)
      @order_item_3.reload
      @order_2.reload

      visit '/merchant'

      expect(page).to have_content("Warning: Item quantity on order #{@order_2.id} exceeds current inventory count")

      @order_item_3.update(quantity: 5)
      @order_item_3.reload
      @order_2.reload

      visit '/merchant'

      expect(page).to_not have_content("Warning: Item quantity on order #{@order_2.id} exceeds current inventory count")
    end

    it 'if several orders exist for an item, and their summed quantity exceeds the Merchants inventory for that item, a warning message is shown' do
      order_item_5 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 4, fulfilled: false)
      @order_1.reload

      visit '/merchant'

      expect(page).to have_content("Warning: Orders summed quantity of item #{@ogre.id} exceed inventory")
      expect(page).to_not have_content("Warning: Orders summed quantity of item #{@giant.id} exceed inventory")

      leviathan = @merchant_1.items.create!(name: 'Leviathan', description: "I'm an Leviathan!", price: 20.50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      visit '/merchant'

      expect(page).to_not have_content("Warning: Orders summed quantity of item #{leviathan.id} exceed inventory")
    end
  end
end
