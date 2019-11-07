module Permissions::Customized
  def checking_thing
    @thing = Thing.find_by(name: params.permit(:thing_name)[:thing_name])

    if @thing.present?
      if !(can? :read, @thing)
        render json: { errors: "Access denied. You didn't own the thing #{@thing.name}"}, status: :unauthorized
      end
    else
      render json: { errors: "Access denied. You didn't own the thing or the device doesnt exist"}, status: :not_found
    end
  end
end
