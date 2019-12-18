module ModelModifiers
  extend ActiveSupport::Concern

  def delete_objects_with_property!(objects, property)
    objects.map{|_, x|
      x.reject! { |y| y.send(property) }
    }
  end
end
