class Merchant::DiscountsController < Merchant::BaseController
  def new
    @merchant = current_user.merchant
  end
end
