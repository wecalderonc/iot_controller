module Utils
  def self.to_constant!(object)
    object.to_s.capitalize.constantize
  end

  def self.symbolize_values!(hash, keys)
    hash.each do |key, value|
      hash[key] = hash[key].to_sym if keys.include? key
    end
  end
end
