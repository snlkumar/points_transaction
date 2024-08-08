# spec/controllers/transactions_controller_spec.rb

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:valid_attributes) {
    { transaction_id: '12345', points: 100, user_id: 1 }
  }

  let(:invalid_attributes) {
    { transaction_id: nil, points: 100, user_id: 1 }
  }

  let(:transaction_data) {
    { transaction_id: '12345', user: 'John Doe', datetime: Time.now }
  }

  before do
    allow_any_instance_of(ExternalApiService).to receive(:fetch_transaction).and_return(transaction_data)
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Transaction" do
        expect {
          post :create, params: { transaction: valid_attributes }
        }.to change(Transaction, :count).by(1)
      end

      it "renders a JSON response with the new transaction" do
        post :create, params: { transaction: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('status' => 'success')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new transaction" do
        post :create, params: { transaction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('status' => 'error')
      end
    end
  end

  describe "POST #bulk_create" do
    context "with valid params" do
      let(:valid_bulk_attributes) {
        [
          { transaction_id: '12345', points: 100, user_id: 1 },
          { transaction_id: '67890', points: 200, user_id: 2 }
        ]
      }

      it "creates multiple Transactions" do
        expect {
          post :bulk_create, params: { transactions: valid_bulk_attributes }
        }.to change(Transaction, :count).by(2)
      end

      it "renders a JSON response with the processed count" do
        post :bulk_create, params: { transactions: valid_bulk_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('status' => 'success', 'processed_count' => 2)
      end
    end

    context "with invalid params" do
      let(:invalid_bulk_attributes) {
        [
          { transaction_id: nil, points: 100, user_id: 1 },
          { transaction_id: '67890', points: 200, user_id: 2 }
        ]
      }

      it "renders a JSON response with errors" do
        post :bulk_create, params: { transactions: invalid_bulk_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('status' => 'error')
      end
    end
  end
end
