require 'rails_helper'

RSpec.describe Custom::Logger do
  let(:logger) { ActiveSupport::Logger.new("log/holi.log")}
  let(:tagged_logger) { ActiveSupport::TaggedLogging.new(logger)}
  let(:error) { { type: :error, message: "this is a horrible error" } }

  describe "#error" do
    after { File.delete(test_log_route) if File.exist?(test_log_route) }

    describe "with logger parametter" do
      let(:test_log_route) { "#{Rails.root}/log/holi.log" }
      let(:test_log) { File.read(test_log_route) }

      it "Should write on custom logger" do
        described_class.error(error, logger: tagged_logger)

        expect(test_log).to include "this is a horrible error"
      end
    end

    describe "without logger parametter" do
      let(:test_log_route) { "#{Rails.root}/log/test.log" }
      let(:test_log) { File.read(test_log_route) }

      it "should write in default logger" do
        described_class.error(error)

        expect(test_log).to include "this is a horrible error"
      end
    end
  end
end
