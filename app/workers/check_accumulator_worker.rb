class CheckAccumulatorWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'downlinks', retry: false, backtrace: true

  def perform(input)
    Utils.symbolize_values!(input, [:action_type, :input_method])

    Shadows::Update::Execute.(input)
  end
end
