class Api::V1::UsersController < Api::V1::BaseController

  # GET /users
  def index    
    @users = User.all
    render json: @users
  end
end
