# frozen_string_literal: true

class ApplicationController < ActionController::API
  around_action :set_time_zone, if: :current_user
  before_action :user_quota, :api_limit

  def current_user
    @current_user ||= User.includes(:hits).find(request.headers["user-id"])
  end

  private

  def user_quota
    render json: { error: 'over quota' } if blocked_user?
  end

  def blocked_user?
    $redis.get(blocked_user_key).present?
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def api_limit
    return if blocked_user?

    ApiLimiter.call(current_user, 'monthly')
  end

  def blocked_user_key
    "id_#{current_user.id}"
  end
end
