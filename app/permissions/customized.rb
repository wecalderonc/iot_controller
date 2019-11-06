module Permissions::Customized
  def checking_thing
    @thing = Thing.find_by(name: params.permit(:thing_name)[:thing_name])

    if !(can? :read, @thing)
      render json: { errors: "Access denied. You didn't own the thing #{@thing.name}"}, status: :unauthorized
    end
  end
end
