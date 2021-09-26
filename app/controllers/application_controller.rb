class ApplicationController < ActionController::API
  # include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActionController::ParameterMissing, with: :params_missing

  # before_action :authenticate_user!

  protected

  def handle_not_found(error)
    render status: :not_found,
           json: {
             error: {
               message: error.message
             }
           }
  end

  def handle_invalid_record(error)
    render status: :unprocessable_entity,
           json: {
             error: {
               message: error.message
             }
           }
  end

  def params_missing(error)
    render status: :unprocessable_entity,
           json: {
             message: error.message
           }
  end
end
