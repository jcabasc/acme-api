# frozen_string_literal: true

class Hit < ApplicationRecord
  belongs_to :user

  MONTHLY_THRESHOLD = 10_000
end
