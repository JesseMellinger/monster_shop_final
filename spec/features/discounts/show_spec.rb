require 'rails_helper'

RSpec.describe 'as a merchant employee' do
  describe 'when I visit a discount show page' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(item_threshold: 20, value: 15.0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I see the item threshold for the discount, the value of the discount, and the name of the merchant that the discount belongs to ' do
      visit discount_path(@discount_1.id)

      expect(page).to have_content("Discount belongs to #{@merchant_1.name}")
      expect(page).to have_content("Item Threshold: #{@discount_1.item_threshold}")
      expect(page).to have_content("Value: #{@discount_1.value}")
    end
  end
end
