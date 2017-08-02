class CartController < ApplicationController
  before_action :authenticate_user!, except: [:add_to_cart, :view_order]

  def add_to_cart
  	line_item = LineItem.new(product_id: params[:product_id], quantity: params[:quantity])
    line_item.total = line_item.product.price * line_item.quantity
    line_item.save

    redirect_back(fallback_location: root_path)
  end

  def view_order
  	@line_items = LineItem.where(order_id: nil)
  end

  def checkout
    line_items = LineItem.where(order_id: nil)
    @order = Order.create(user_id: current_user.id, subtotal: 0)

    line_items.each do |line_item|
      line_item.product.quantity -= line_item.quantity
      line_item.product.save

      line_item.update(order_id: @order.id)
      @order.subtotal += line_item.total
    end

    @order.sales_tax = @order.subtotal * 0.0825
    @order.grand_total = @order.subtotal + @order.sales_tax

    @order.save
  end

  def order_complete
    @order = Order.find(params[:order_id])
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'Rails Stripe customer',
      :currency => 'usd'
    )

    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to cart_path
  end
end
