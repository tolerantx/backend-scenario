class Api::V1::RecipientsController < ApplicationController
  def index
    render json: school_recipients
  end

  def create
    if recipient.save
      render status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def update
    if recipient.update(recipient_params)
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  def destroy
    if recipient.destroy
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private

  def recipient_params
    params.require(:recipient).permit(:name, :address)
  end

  def school
    @school ||= School.find_by!(id: params[:school_id])
  end

  def recipient
    @recipient ||= if  params[:id]
                     Recipient.find_by!(id: params[:id])
                   else
                     Recipient.new(recipient_params.merge(school_id: school.id))
                   end
  end

  def school_recipients
    @school_recipients ||= Recipient.filter_by(school_id: school.id) if school
  end
end
