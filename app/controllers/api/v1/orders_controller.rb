class Api::V1::OrdersController < ApplicationController
  def index
    render json: school_orders
  end

  def create
    if order.save
      render status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def update
    if order.update(order_params)
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order)
      .permit(:date, :status, items_attributes: %i[id recipient_id gift_type quantity])
  end

  def school
    @school ||= School.find_by!(id: params[:school_id])
  end

  def order
    @order ||= if params[:id]
                 school.orders.find_by!(id: params[:id])
               else
                 school.orders.new(order_params.merge(school_id: school.id))
               end
  end

  def school_orders
    @school_orders ||= Order.filter_by(school_id: school.id) if school
  end
end
