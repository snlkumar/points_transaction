# frozen_string_literal: true

# spec/requests/api/v1/transactions_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do
  let(:valid_attributes) do
    {
      transaction: {
        transaction_id: '12345',
        points: 100,
        user_id: 1
      }
    }
  end

  let(:invalid_attributes) do
    {
      transaction: {
        transaction_id: nil,
        points: nil,
        user_id: nil
      }
    }
  end

  before do
    stub_request(:get, 'https://jsonplaceholder.typicode.com/posts/1')
      .to_return(status: 200, body: { user: 'adam ryan', transaction_id: 1234,
                                      datetime: DateTime.now }.to_s, headers: {})
  end

  describe 'POST /api/v1/transactions, for single route' do
    context 'with valid parameters' do
      it 'creates a new Transaction' do
        expect do
          post single_api_v1_transactions_path, params: valid_attributes
        end.to change(Transaction, :count).by(1)
      end

      it 'renders a JSON response with the new transaction' do
        post single_api_v1_transactions_path, params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('success')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Transaction' do
        expect do
          post single_api_v1_transactions_path, params: invalid_attributes
        end.to change(Transaction, :count).by(0)
      end

      it 'renders a JSON response with errors for the new transaction' do
        post single_api_v1_transactions_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('error')
      end
    end
  end

  describe 'POST /api/v1/transactions/bulk_create' do
    let(:bulk_valid_attributes) do
      {
        transactions: [
          { transaction_id: '12345', points: 100, user_id: 1 },
          { transaction_id: '67890', points: 200, user_id: 2 }
        ]
      }
    end

    let(:bulk_invalid_attributes) do
      {
        transactions: [
          { transaction_id: nil, points: nil, user_id: nil },
          { transaction_id: '67890', points: 200, user_id: 2 }
        ]
      }
    end

    context 'with valid parameters' do
      it 'creates multiple Transactions' do
        expect do
          post bulk_api_v1_transactions_path, params: bulk_valid_attributes
        end.to change(Transaction, :count).by(2)
      end

      it 'renders a JSON response with the processed count' do
        post bulk_api_v1_transactions_path, params: bulk_valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('success')
      end
    end

    context 'with invalid parameters' do
      it 'does not create multiple Transactions' do
        expect do
          post bulk_api_v1_transactions_path, params: bulk_invalid_attributes
        end.to change(Transaction, :count).by(0)
      end

      it 'renders a JSON response with errors for the bulk create' do
        post bulk_api_v1_transactions_path, params: bulk_invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('error')
      end
    end
  end
end
