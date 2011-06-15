module Defuzz
	DEFUZZ_METHODS = {
		:lom => :least_of_maximum,
		:mom => :middle_of_maximum,
		:bom => :biggest_of_maximum,
		:aom => :average_of_maximum,
		:cog => :center_of_gravity
	}

	@@defuzz_method = nil
	
	# Sets the method for defuzzification. Avalaible norms are defined in <em>DEFUZZ_METHODS</em>
	def Defuzz.defuzz_method(m)
		if DEFUZZ_METHODS.has_key?(m)
			@@defuzz_method = m
		else
			sm = ""
			DEFUZZ_METHODS.each_key do |k|
				sm << "#{k} "
			end
			raise ArgumentError, "defuzzification method #{m} is not supported\nSupported methods: #{sm}"
		end
	end
	
	private
	
	def least_of_maximum(fun)
		found = fun.points[0]
		fun.points.each do |p|
			found = p if p.y > found.y
		end
		return found
	end
	
	def middle_of_maximum(fun)
		found = []
		found.push fun.points[0]
		fun.points[1..fun.points.length].each do |p|
			if p.y == found[0].y
				found.push p
			end
			if p.y > found[0].y
				found.clear
				found.push p
			end
		end
		return found[found.length/2]
	end
	
	def biggest_of_maximum(fun)
		found = fun.points[0]
		fun.points.each do |p|
			found = p if p.y >= found.y
		end
		return found
	end
	
	def average_of_maximum(fun)
		found = []
		found.push fun.points[0]
		fun.points[1..fun.points.length].each do |p|
			if p.y == found[0].y
				found.push p
			end
			if p.y > found[0].y
				found.clear
				found.push p
			end
		end
		sum = 0
		found.each do |p|
			sum += p.x
		end
		average = sum / found.length.to_f
		return Point.new(average, fun.at(average))
	end
	
	def center_of_gravity(fun)
		sum_xy = 0
		sum_y = 0
		fun.points.each do |p|
			sum_xy += p.x*p.y
			sum_y += p.y
		end
		if sum_y == 0
			return fun.points[fun.points.lenght/2]
		else
			Point.new(sum_xy/sum_y, fun.at(sum_xy/sum_y))
		end
	end
end