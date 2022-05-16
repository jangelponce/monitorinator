class Api::V1::WorkshiftsController < Api::V1::BaseController
  before_action :set_workshift, only: %i[ show update destroy ]
  before_action :set_service

  # GET /workshifts
  def index    
    @workshifts = @service.workshifts.accepted.order(:timestamp)
    render json: @workshifts
  end

  # GET /workshifts/1
  def show
    render json: @workshift
  end

  # POST /workshifts
  def create
    @workshift = Workshift.new(workshift_params)

    if @workshift.save
      render json: @workshift, status: :created
    else
      render json: @workshift.errors, status: :unprocessable_entity
    end
  end

  def calculate
    beginning_of_week = if params[:date]
      DateTime.new(*params[:date].split("-").map(&:to_i))
    else
      DateTime.now
    end.beginning_of_week
    
    current_day = beginning_of_week
    end_of_week = current_day.end_of_week

    while end_of_week > current_day
      workshifts = @service.workshifts.where(timestamp: [current_day.beginning_of_day..current_day.end_of_day])
      ranking = workshifts.group(:user_id).order('count_id desc').count('id').keys
      
      if ranking.any?
        workshifts.update_all(status: :pending)
        (0..23).map do |hour|
          ranking.each do |user_id|
            datetime = DateTime.new(current_day.year, current_day.month, current_day.day, hour, 0)
            ws = workshifts.where(user_id: user_id, timestamp: datetime)
            if ws.any?
              ws.update(status: :accepted)
              break
            end
          end
        end
      end

      current_day = current_day.beginning_of_day + 1.day
    end
    
    head :ok
  end

  def week
    beginning_of_week = if params[:date]
      DateTime.new(*params[:date].split("-").map(&:to_i))
    else
      DateTime.now
    end.beginning_of_week
    
    current_day = beginning_of_week
    end_of_week = current_day.end_of_week

    @workshifts = {
      week: {
        beginning_of_week: beginning_of_week, 
        end_of_week: end_of_week
      },
      days: []
    }

    while end_of_week > current_day
      begin_of_the_day = 19
      end_of_the_day = 23
      
      workshifts = (begin_of_the_day..end_of_the_day).map do |hour|
        datetime = DateTime.new(current_day.year, current_day.month, current_day.day, hour, 0)
        ws = @service.workshifts.where(timestamp: datetime).includes(:user).as_json(include: :user)
        accepted = ws.find do |w|
          w["status"] === "accepted"
        end
        {
          hour: datetime,
          available: ws,
          workshift: accepted
        }
      end
      
      @workshifts[:days] << {
        day: current_day,
        workshifts: workshifts
      }

      current_day = current_day.beginning_of_day + 1.day
    end
    
    render json: @workshifts
  end

  # PATCH/PUT /workshifts/1
  def update
    if @workshift.update(workshift_params)
      render json: @workshift
    else
      render json: @workshift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /workshifts/1
  def destroy
    @workshift.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workshift
      @workshift = Workshift.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workshift_params
      params.require(:workshift).permit(:timestamp, :user_id, :service_id)
    end

    def set_service
      @service = Service.find(params[:service_id])
    end
end
