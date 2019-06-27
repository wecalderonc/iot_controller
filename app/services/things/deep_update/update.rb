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
    input[:type].include?('scheduled')
      true
    else
      nil
    end
  end

  def check_accumulator(input)
    Accumulators::CheckState::Execute.new.(input)
  end

  def update_shadow_state(input)
    Amazon::Iot::Shadows::Update::Execute.new.(input)
  end
end
