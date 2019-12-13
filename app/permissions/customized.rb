module Permissions::Customized
  def check_thing_permission
    @thing = Thing.find_by(name: params.permit(:thing_name)[:thing_name])

    options = {
      true => lambda { |thing| thing_present(thing) },
      false => lambda { |thing| json_response({ errors: "Access denied. You didn't own the thing or the device doesnt exist"}, :not_found) }
    }

    options[@thing.present?].(@thing)
  end

  # TODO CHANGE JSON_RESPONSE to another answer
  def thing_present(thing)
    if not (can? :read, thing)
      json_response({ errors: "Access denied. You didn't own the thing #{thing.name}"}, :unauthorized)
    end
  end
end
