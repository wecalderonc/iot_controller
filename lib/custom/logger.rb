module Custom::Logger

  def self.error(object, logger: Rails.logger)
    logger.tagged(object[:type]) do
      logger.error { "\n #{ object.inspect } \n" }
    end
  end
end
