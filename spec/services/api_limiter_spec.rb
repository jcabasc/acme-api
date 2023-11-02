# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiLimiter do
  describe 'call' do
    let(:user) { instance_double(::User, id: 1, time_zone: 'Bogota') }
    let(:frequency) { 'monthly' }
    let(:blocked_user_key) { "id_#{user.id}" }

    before do
      Timecop.freeze(Time.local(2023, 11, 1, 23, 0, 0))
    end

    after do
      Timecop.return
    end

    context 'when hit count is below threshold' do
      subject(:api_limiter) { described_class.call(user, frequency) }

      it 'sets the key with the correct expiration time and does not block the user' do
        expect($redis).to receive(:set).with('id_1_202311', 1)
        expect($redis).to receive(:expire).with('id_1_202311', 2_491_200)

        api_limiter
      end

      it 'does not block the user' do
        expect($redis.get(blocked_user_key)).to eq(nil)
      end
    end

    context 'when hit count is equal the threshold' do
      subject(:api_limiter) { described_class.call(user, frequency) }

      before do
        $redis.set("id_1_202311", Hit::MONTHLY_THRESHOLD)
      end

      it 'increments the key' do
        increment =  Hit::MONTHLY_THRESHOLD + 1
        api_limiter

        expect($redis.get('id_1_202311')).to eq(increment.to_s)
      end

      it 'does block the user' do
        api_limiter

        expect($redis.get(blocked_user_key)).to be_present
      end
    end

    context 'with user from different timezones' do
      let(:user2) { instance_double(::User, id: 2, time_zone: 'Sydney') }

      before do
        Time.use_zone('Bogota') do
          described_class.call(user, frequency)
        end

        Time.use_zone('Sydney') do
          described_class.call(user2, frequency)
        end
      end

      it 'sets the correct expiration time for a user in Sydney' do
        Time.use_zone('Sydney') do
          expect($redis.ttl("id_2_202311")).to eq(2_451_600) # remaining time in seconds
        end
      end

      it 'sets the correct expiration time for a user in Bogota' do
        Time.use_zone('Bogota') do
          expect($redis.ttl("id_1_202311")).to eq(2_509_200) # remaining time in seconds
        end
      end

      it 'the difference between the timestamp is 16 hours' do
        difference_in_seconds = $redis.ttl("id_1_202311") - $redis.ttl("id_2_202311")
        difference_in_minutes = difference_in_seconds / 60
        difference_in_hours = difference_in_minutes / 60

        expect(difference_in_hours).to eq(16)
      end
    end
  end
end
