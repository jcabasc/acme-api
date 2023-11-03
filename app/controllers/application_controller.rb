class ApplicationController < ActionController::API
  around_action :set_time_zone, if: :current_user
  before_action :user_quota

  def current_user
    @current_user ||= User.includes(:hits).find(request.headers["user-id"])
  end

  private

  def user_quota
    render json: { error: 'over quota' } if current_user.count_hits >= Hit::MONTHLY_THRESHOLD
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
