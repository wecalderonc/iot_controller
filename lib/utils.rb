module Utils

  def self.parse_date(date)
    date.present? ? date.strftime('%a %d %b %Y') : ""
  end

  def self.to_constant(object)
    object.to_s.classify.constantize
  end

  def self.symbolize_values(hash, keys)
    hash
      .slice(*keys)
      .transform_values(&:to_sym)
      .merge hash.except(*keys)
  end

  def self.camelize_symbol(object)
    object.to_s.camelize
  end

  def self.last_digit(object)
    object[-1]
  end
end
