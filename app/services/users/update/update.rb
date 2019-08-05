require 'dry/transaction/operation'

class Users::Update::Update
  include Dry::Transaction::Operation

  map :update_country
  map :update_params
end
