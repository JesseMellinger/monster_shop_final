class DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new()
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.create(discount_params)
    if discount.save
      flash[:success] = "Discount created!"
      redirect_to '/merchant'
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to new_discount_path
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to "/merchant"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to edit_discount_path(@discount.id)
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to discounts_path
  end

  private
  def discount_params
    params.require(:discount).permit(:item_threshold, :value)
  end
end
