class Api::V1::OrderItemsController < ApplicationController
  def index
    render json: order_items
  end

  def create
    if item.save
      render status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def update
    if item.update!(order_item_params)
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:recipient_id, :gift_type, :quantity)
  end

  def order
    @order ||= Order.find_by!(id: params[:order_id])
  end

  def item
    @item ||= if params[:id]
                order.items.find_by!(id: params[:id])
              else
                order.items.new(order_item_params.merge(order_id: order.id))
              end
  end

  def order_items
    @order_items ||= OrderItem.filter_by(order_id: order.id) if order
  end
end
