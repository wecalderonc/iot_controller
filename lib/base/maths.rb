module Base::Maths
  def self.hexa_to_int(value)
    value.to_i(16)
  end

  RuleOfThree = -> a, b, c do
    a * (b / c)
  end
end
