require 'dry/transaction/operation'

class Shadows::Update::ReadyForCut
  include Dry::Transaction::Operation

  def call(input)
    if ready_for_cut?(input)
      Success input
    else
      CheckAccumulatorWorker.perform_in(5.seconds.from_now, input)
      Failure Errors.general_error("Not ready for cut, calling worker", self.class)
    end
  end

  private

  def ready_for_cut?(input)
    last_acc = Base::Maths.hexa_to_int(input[:last_accumulator])
    cut_in = Base::Maths.hexa_to_int(input[:value])

    {
      consumption: Calculators::WaterMetter::ReadyForConsumption.(last_acc, cut_in),
      accumulated_value: Calculators::WaterMetter::ReadyForAccValue.(last_acc, cut_in)
    }[input[:input_method]]
  end
end
