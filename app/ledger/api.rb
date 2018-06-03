require 'sinatra/base'
require 'ledger/lib/api_authentication'
require 'ledger/lib/json_body'

module Ledger
  class API < Sinatra::Application
    use Lib::APIAuthentication
    use Lib::JSONBody

    include Import['operations.create_customer']

    FAILED = 'No luck'

    post '/customers' do
      create_customer.(account, data).fmap { |customer|
        JSON.dump(
          id: customer.id,
          name: customer.name
        )
      }.value_or { FAILED }
    end

    def account
      env.fetch(Lib::APIAuthentication::ACCOUNT_KEY)
    end

    def data
      env.fetch(Lib::JSONBody::JSON_KEY)
    end
  end
end