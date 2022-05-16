class Api::V1::ServicesController < Api::V1::BaseController
  before_action :set_service, only: %i[ show update destroy weeks ]

  # GET /api/v1/services
  def index
    @services = Service.all

    render json: @services
  end

  # GET /api/v1/services/1
  def show
    render json: @service
  end

  # POST /api/v1/services
  def create
    @service = Service.new(service_params)

    if @service.save
      render json: @service, status: :created
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/services/1
  def update
    if @service.update(service_params)
      render json: @service
    else
      render json: @service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/services/1
  def destroy
    @service.destroy
  end

  def weeks
    today = DateTime.now
    first_week = if workshift = @service.workshifts.accepted.order(:timestamp).first
      workshift_date = workshift.timestamp.to_datetime
      if today > workshift_date
        workshift_date
      else
        today
      end
    else
      today
    end.beginning_of_week

    last_week = today + 4.weeks

    @weeks = (first_week..last_week).step(7).map(&:to_date)
    
    render json: @weeks
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(:name)
    end
end
