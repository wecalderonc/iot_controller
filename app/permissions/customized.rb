module Permissions::Customized
  def checking_thing
    @thing = Thing.find_by(name: params.permit(:thing_name)[:thing_name])

    options = {
      true => hola(@thing),
      false => render
    }

    options[@thing.present?]
  end

  def hola(thing)
    if not (can? :read, thing)
      render json: { errors: "Access denied. You didn't own the thing #{thing.name}"}, status: :unauthorized
    end
  end

  def render
    render json: { errors: "Access denied. You didn't own the thing or the device doesnt exist"}, status: :not_found
  end
end
