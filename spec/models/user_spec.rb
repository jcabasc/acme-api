# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe '.count_hits' do
    subject(:user) { User.create }

    context "with hits on the current month (Nov)" do
      before do
        Timecop.travel(Time.local(2023, 11, 1, 12, 0, 0))
        2.times do
          user.hits.create(endpoint: "endpoint1")
        end
      end

      after do
        Timecop.return
      end

      it "returns 2 counts" do
        expect(user.count_hits).to eq(2)
      end
    end

    context "without hits on the current month (Nov)" do
      before do
        Timecop.travel(Time.local(2023, 10, 31, 12, 0, 0))
        2.times do
          user.hits.create(endpoint: "endpoint1")
        end
        Timecop.return

        Timecop.travel(Time.local(2023, 11, 1, 12, 0, 0))
      end

      after do
        Timecop.return
      end

      it "returns 0 counts" do
        expect(user.count_hits).to eq(0)
      end
    end

    context "with a different time zone" do
      before do
        Timecop.travel(Time.local(2023, 10, 1, 12, 0, 0))
        2.times do
          user.hits.create(endpoint: "endpoint1")
        end

        Timecop.return
        Timecop.freeze(Time.local(2023, 10, 31, 12, 59, 59))
      end

      after do
        Timecop.return
      end

      it 'returns 2 counts even though current time is Nov 1st' do
        Time.use_zone("Sydney") do
          # Datetimes attributes are expressed in the correct time zone
          expect(user.created_at.time_zone.name).to eq("Sydney")

          # Current time is Nov 1st
          expect(Time.zone.now.strftime("%Y-%m-%d")).to eq("2023-11-01")

          expect(user.count_hits).to eq(2)
        end
      end
    end
  end
end
