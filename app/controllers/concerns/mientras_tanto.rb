module MientrasTanto
  def self.aja(thing_id, model_name)
    thing = Thing.find_by(id: thing_id)

      if thing.present?
        { result: thing.uplinks.send(model_name.to_sym), status: :ok }
      else
        { result: { errors: "Thing doesn't exist" }, status: :not_found }
      end
  end
end
