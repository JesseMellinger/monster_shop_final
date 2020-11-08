require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_numericality_of(:item_threshold).only_integer}
    it {should validate_numericality_of(:value)}
    it {should validate_presence_of :item_threshold}
    it {should validate_presence_of :value}
  end
end
