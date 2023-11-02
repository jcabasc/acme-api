# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestsController do
  describe 'GET /tests' do
    let(:user) { User.create }
    let(:headers) { { 'user-id' => user.id } }

    context 'when hits are below the threshold' do
      subject(:make_request) { get '/tests', headers: }

      it 'returns ok status code' do
        make_request

        expect(response).to have_http_status(:ok)
      end

      it 'returns a successfull plain message' do
        make_request

        expect(response.body).to eq('You are welcome!')
      end
    end

    context 'when hits are above or equal the threshold' do
      subject(:make_request) { get '/tests', headers: }

      before do
        allow_any_instance_of(User).to receive(:count_hits).and_return(Hit::MONTHLY_THRESHOLD)
      end

      it 'returns ok status code' do
        make_request

        expect(response).to have_http_status(:ok)
      end

      it 'returns an error message' do
        make_request

        expect(JSON.parse(response.body)['error']).to eq('over quota')
      end
    end
  end
end
