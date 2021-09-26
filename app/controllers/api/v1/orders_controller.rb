class Api::V1::OrdersController < ApplicationController
  def index
    render json: school_orders
  end

  def create
    render status: :created if order.save!
  end

  def update
    render status: :accepted if order.update!(order_params)
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
                 Order.find_by!(id: params[:id])
               else
                 Order.new(order_params.merge(school_id: school.id))
               end
  end

  def school_orders
    @school_orders ||= Order.filter_by(school_id: school.id) if school
  end
end
