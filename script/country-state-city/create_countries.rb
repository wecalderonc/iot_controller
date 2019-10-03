CS.countries.each do |code_iso, name|
  begin
    Country.create(name: name, code_iso: code_iso)
    puts "#{name}.created......................................................."
  rescue
    puts "#{name}.fallo........................................................."
  end
end
