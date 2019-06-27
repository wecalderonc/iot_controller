require 'dry/transaction/operation'

class Things::UpdateShadow::Update
  include Dry::Transaction::Operation

  def call(input)
    Dry::Monads.Maybe(ChooseAction.())
      .fmap { check_accumulator(input) }
      .value_or { update_shadow_state(input) }
  end

  private

  ChooseAction = -> do
    if [:scheduled_cut, :scheduled_restore_supply].include?(input[:type])
      true
    else
      nil
    end
  end

  def check_accumulator(input)
    Amazon::Iotdata::CheckAccumulator.new.execute(input)
  end

  def update_shadow_state(input)
    Amazon::Iotdata::UpdateShadowDesiredState.new.execute(input)
  end
end
