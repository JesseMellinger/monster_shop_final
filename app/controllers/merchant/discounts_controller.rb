class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def edit
    @merchant = current_user.merchant
  end

  def update
    merchant = current_user.merchant
    if merchant.update(merchant_discount_params)
      redirect_to "/merchant"
    else
      generate_flash(merchant)
      render :edit
    end
  end

  def destroy
    merchant = current_user.merchant
    merchant.update(discount: 0)
    redirect_to "/merchant"
  end

  private
  def merchant_discount_params
    params.require(:merchant).permit(:discount)
  end
end
