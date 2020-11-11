class Merchant::DashboardController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
    @items = @merchant.get_items
  end
end
