def fuel_required(mass)
	[(mass.to_f / 3).floor - 2, 0].max
end

def fuel_required_recursive(mass)
	return 0 unless fuel_required(mass) > 0

	fuel_required(mass) + fuel_required_recursive(fuel_required(mass))
end

def total_fuel_required(modules)
	modules.reduce(0) { |total, n| total + fuel_required_recursive(n.to_i) }
end

input = File.foreach('INPUT.txt')
puts "Fuel required: " << total_fuel_required(input).to_s << "\n"
