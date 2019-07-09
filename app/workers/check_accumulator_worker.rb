class CheckAccumulatorWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'downlinks', retry: false, backtrace: true

  def perform(input)
    input = input.deep_symbolize_keys
    input = { value: input[:value], input_method: input[:input_method].to_sym, thing_name: input[:thing_name], action: input[:action].to_sym, type: input[:type].to_sym }
    Shadows::Update::Execute.(input)
  end
end
