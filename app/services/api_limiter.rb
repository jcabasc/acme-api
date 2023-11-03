# rubocop:disable Style/StringLiterals, Style/GlobalVars, Naming/AccessorMethodName
# frozen_string_literal: true

# Handles API limits
class ApiLimiter
  REQUEST_LIMIT = {
    monthly: Hit::MONTHLY_THRESHOLD,
    daily: 333
  }.freeze

  TIME_FORMAT = {
    monthly: "%Y%m",
    daily: "%Y%m%d"
  }.freeze

  def self.call(...)
    new(...).call
  end

  def initialize(user, frequency)
    @user = user
    @frequency = frequency.to_sym
  end

  def call
    if $redis.get(user_key)
      number_of_requests = $redis.incr(user_key)
      check_limit!(number_of_requests)
    else
      set_key_and_expiration(user_key)
    end
  end

  private

  attr_reader :user, :frequency

  def check_limit!(number_of_requests)
    return if number_of_requests < REQUEST_LIMIT[frequency]

    set_key_and_expiration(blocked_user_key)
  end

  def user_key
    "id_#{user.id}_#{Time.current.strftime(TIME_FORMAT[frequency])}"
  end

  def blocked_user_key
    "id_#{user.id}"
  end

  def expiration_timespan
    period_end = frequency == :monthly ? 'end_of_month' : 'end_of_day'

    (Time.current.send(period_end) - Time.current).ceil
  end

  def set_key_and_expiration(key)
    $redis.set(key, 1)
    $redis.expire(key, expiration_timespan)
  end
end

# rubocop:enable Style/StringLiterals, Style/GlobalVars, Naming/AccessorMethodName
