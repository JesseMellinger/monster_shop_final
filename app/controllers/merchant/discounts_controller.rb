class Merchant::DiscountsController < Merchant::BaseController
  def edit
    @merchant = current_user.merchant
  end

  def update
    merchant = current_user.merchant
    if merchant.update(merchant_discount_params)
      redirect_to "/merchant/"
    else
      generate_flash(merchant)
      render :edit
    end
  end

  private
  def merchant_discount_params
    params.require(:merchant).permit(:discount)
  end
end
