# frozen_string_literal: true

# spec/services/external_api_service_spec.rb

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ExternalApiService do
  before do
    stub_request(:get, 'https://jsonplaceholder.typicode.com/posts/1')
      .to_return(status: 200, body: '', headers: {})
  end

  describe '#fetch_transaction' do
    context 'when the response is successful' do
      it 'returns transaction data' do
        service = ExternalApiService.new
        transaction_id = '12345'
        result = service.fetch_transaction(transaction_id)

        expect(result).to include(:transaction_id, :user, :datetime)
        expect(result[:transaction_id]).to eq(transaction_id)
        expect(result[:user]).to be_a(String)
        expect(result[:datetime]).to be_a(Time)
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:get, 'https://jsonplaceholder.typicode.com/posts/1')
          .to_return(status: 500, body: '', headers: {})
      end

      it 'raises an error' do
        service = ExternalApiService.new
        expect { service.fetch_transaction('12345') }.to raise_error('Error fetching data: ')
      end
    end
  end

  describe '#random_datetime' do
    it 'returns a datetime within the expected range' do
      service = ExternalApiService.new
      from = 10.months.ago
      to = Time.now
      datetime = service.random_datetime(from, to)

      expect(datetime).to be >= from
      expect(datetime).to be <= to
    end
  end
end
