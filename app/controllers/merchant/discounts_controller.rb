class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new()
  end

  def create
    merchant = current_user.merchant
    @item = merchant.discounts.create(discount_params)
    if @item.save
      flash[:success] = "Discount created!"
      redirect_to '/merchant'
    else
      flash[:error] = "Please fill in both fields"
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to "/merchant"
    else
      generate_flash(merchant)
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.require(:discount).permit(:item_threshold, :value)
  end
end
