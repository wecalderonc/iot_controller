require 'dry/transaction'

module Users::Update
  include Dry::Transaction
  _, Update = Common::TxMasterBuilder.new do
    step :update_params,     with: Users::Update::Params.new
    step :update_country,    with: Users::Update::Country.new
  end.Do
end
