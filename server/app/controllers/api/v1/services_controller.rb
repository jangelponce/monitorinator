class Api::V1::ServicesController < Api::V1::BaseController
  before_action :set_service, only: %i[ show update destroy calendar ]

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

  def calendar
    weeks = [
      {
        week: "Semana 10",
        days: [
          {
            day: Date.today,
            workshifts: [
              {
                hour: Time.now.hour,
                assigned_to: "Julian"
              }
            ]
          }
        ]
      }
    ]
    render json: weeks
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
