class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :item_threshold,
                        :value

  validates :item_threshold, numericality: { only_integer: true }, uniqueness: true
  validates_numericality_of :value
end
