require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CheckAccumulatorWorker do
  let(:accumulator) { create(:accumulator) }
  let(:thing)       { create(:thing) }
  let(:input)       { { thing: thing, action_type: :scheduled_cut } }
  let(:subject)     { described_class }

  before do
    Sidekiq::Worker.clear_all
    Sidekiq::Testing.fake!
    Timecop.freeze(Time.new(2019,2,11))
  end

  after do
    Sidekiq::Worker.clear_all
    Timecop.return
  end

  describe "#perform" do
    it "Should enqueue the worker" do
      allow(Shadows::Update::Execute).to receive(:call)

      expect { subject.perform_async(input) }.to change(subject.jobs, :size).by(1)

      Sidekiq::Worker.drain_all
    end
  end
end
