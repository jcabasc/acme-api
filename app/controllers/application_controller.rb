class ApplicationController < ActionController::API
  before_action :user_quota

  def current_user
    @current_user ||= User.includes(:hits).find(request.headers["user-id"])
  end

  def user_quota
    render json: { error: 'over quota' } if current_user.count_hits >= Hit::MONTHLY_THRESHOLD
  end
end
