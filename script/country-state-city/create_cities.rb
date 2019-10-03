State.all.each do |state|
  puts "Creating  #{state.name} cities........................................"

  CS.cities(state.code_iso, state.country.code_iso).each do |name|
    begin
      City.create(name: name, state: state)
      puts "#{name}.created......................................................."
    rescue
      puts "#{name}.fallo........................................................."
    end
  end
end
