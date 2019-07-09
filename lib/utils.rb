module Utils
  def self.to_constant(object)
    object.to_s.capitalize.constantize
  end

  def self.symbolize_values(hash, keys)
    hash
      .slice(*keys)
      .transform_values(&:to_sym)
      .merge hash.except(*keys)
  end
end
