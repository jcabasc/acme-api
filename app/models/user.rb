# frozen_string_literal: true

class User < ApplicationRecord
  has_many :hits

  def count_hits
    start = Time.now.beginning_of_month
    hits = self.hits.where('created_at > ?', start).count
    return hits
  end
end
