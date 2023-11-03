# frozen_string_literal: true

class User < ApplicationRecord
  has_many :hits

  def count_hits
    start = Time.current.beginning_of_month
    self.hits.where('created_at > ?', start).count
  end
end
