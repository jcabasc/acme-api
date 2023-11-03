# frozen_string_literal: true

class TestsController < ApplicationController
  before_action :log_hit

  def index
    render json: { success: 'This is fine!' }
  end

  private

  def log_hit
    current_user.hits.create(endpoint: "#{controller_name}/#{action_name}")
  end
end
