class CheckAccumulatorWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'downlinks', retry: false, backtrace: true

  def perform(input)
    input.symbolize_keys!
    parsed_input = Utils.symbolize_values(input, [:action_type, :input_method])

    Shadows::Update::Execute.(parsed_input)
  end
end
