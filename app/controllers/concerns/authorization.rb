module Authorization
  def authorize(model_array)
    model_array.select { |instance| authorize! :read, instance }
  end
end
