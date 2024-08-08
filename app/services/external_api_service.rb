# app/services/external_api_service.rb

require 'httparty'

class ExternalApiService
  include HTTParty
  base_uri 'https://jsonplaceholder.typicode.com'

  def fetch_transaction(transaction_id)
    # Simulating a response from the external API
    response = self.class.get('/posts/1')
    if response.success?
      {transaction_id: transaction_id, user: Faker::Name.name, datetime: random_datetime}
    else
      raise "Error fetching data: #{response.message}"
    end
  end

  def random_datetime(from = 10.months.ago, to = Time.now)
    Time.at(from + rand * (to.to_f - from.to_f))
  end
end
