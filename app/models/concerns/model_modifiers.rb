module ModelModifiers
  extend ActiveSupport::Concern

  def delete_objects_with_property!(thing_with_objects, property)
    thing_with_objects.map{|_, objets_array|
      objets_array.reject! { |object| object.send(property) }
    }
  end
end
