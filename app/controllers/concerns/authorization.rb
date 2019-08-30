module Authorization
  def authorize(model_array)
    model_array.success.select { |instance| authorize! :read, instance }
  end
end
