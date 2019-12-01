def fuel_required(mass)
	(mass.to_f / 3).floor - 2
end

def total_fuel_required(modules)
	modules.reduce(0) { |total, n| total + fuel_required(n.to_i) }
end

input = File.foreach('INPUT.txt')
puts "Fuel required: " << total_fuel_required(input).to_s << "\n"
