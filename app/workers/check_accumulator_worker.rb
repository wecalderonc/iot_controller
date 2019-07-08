class CheckAccumulatorWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'downlinks', retry: false, backtrace: true

  def perform(input)
    Shadows::Update::Execute.(input)
  end
end
