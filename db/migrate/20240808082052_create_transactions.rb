# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :points
      t.string :user_id # if we create user model then it would be a user foreign key but i am considering it as a column
      t.string :transaction_id
      t.json :transaction_data
      t.timestamps
    end
  end
end
