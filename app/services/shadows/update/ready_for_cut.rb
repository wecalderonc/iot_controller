require 'dry/transaction/operation'

class Shadows::Update::ReadyForCut
  include Dry::Transaction::Operation

  LIMIT_VALUE = 0xffffffff

  def call(input)
    if ready_for_cut?(input)
      Success input
    else
      #Failure CheckAccumulatorWorker.perform_in(5.seconds.from_now, input)
      Failure "not ready for cut"
    end
  end

  private

  def ready_for_cut?(input)
    last_acc = Base::Maths.hexa_to_int(input[:last_accumulator])
    cut_in = Base::Maths.hexa_to_int(input[:value])

    {#arreglar estas matematicas para que sean entendibles
      consumption: (last_acc + cut_in) < LIMIT_VALUE,
      accumulated_value: last_acc < cut_in
    }[input[:input_method]]
  end

end
