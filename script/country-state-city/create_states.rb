Country.all.each do |country|
  puts "Creating  #{country.name} states........................................"

  CS.states(country.code_iso).each do |code, name|
    begin
      State.create(name: name, code_iso: code, country: country)
      puts "#{name}.created......................................................."
    rescue
      puts "#{name}.fallo........................................................."
    end
  end
end
