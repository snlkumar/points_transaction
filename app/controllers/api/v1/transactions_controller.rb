# frozen_string_literal: true

# This controller will store the users points transaction
module Api
  module V1
    class TransactionsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_valid_transaction_params

      def create
        transaction_data = ExternalApiService.new.fetch_transaction(@transaction_params[:transaction_id])
        transaction = Transaction.new(@transaction_params.merge!(transaction_data: transaction_data))
        if transaction.save
          render json: { status: 'success', transaction_id: transaction.transaction_id }, status: :ok
        else
          render json: { status: 'error', errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def bulk_create
        # I would prefer to process bulk_create operation through background job.
        # Because of the required response i am processing it in line.

        transactions = @transaction_params.map do |transaction_params|
          transaction_data = ExternalApiService.new.fetch_transaction(transaction_params[:transaction_id])
          Transaction.new(transaction_params.merge!(transaction_data: transaction_data))
        end

        if transactions.all?(&:save)
          render json: { status: 'success', processed_count: transactions.count }, status: :created
        else
          errors = transactions.flat_map { |t| t.errors.full_messages }
          render json: { status: 'error', errors: errors }, status: :unprocessable_entity
        end
      end

      private

      def set_valid_transaction_params
        @transaction_params = if params[:action] == 'bulk_create'
                                bulk_transaction_params
                              else
                                single_transaction_params
                              end
      end

      def bulk_transaction_params
        params.require(:transactions).map do |transaction|
          transaction.permit(:transaction_id, :points, :user_id)
        end
      end

      def single_transaction_params
        params.require(:transaction).permit(:transaction_id, :points, :user_id)
      end
    end
  end
end
