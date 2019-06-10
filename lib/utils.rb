module Utils
  def self.to_constant(value)
    value.to_s.capitalize.constantize
  end
end
