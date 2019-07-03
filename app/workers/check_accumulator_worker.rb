class CheckAccumulatorWorker
  include Sidekiq::Worker

  def perform(input)
    Shadows::Update::Execute.(input)
  end
end
