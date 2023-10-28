class TestsController < ApplicationController
  before_action :log_hit

  def index
    render status: :ok, plain: "You are welcome!"
  end

  private

  def log_hit
    current_user.hits.create(endpoint: "#{self.controller_name}/#{self.action_name}")
  end
end
