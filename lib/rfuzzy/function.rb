# Basic 2d adherence function
class Function
	include Norm
	include Defuzz
	
	EPSILON = 1.0e-10
	
	@@step_size = nil
	
	# Sets the step resolution used if automatic step detection is used
	def self.step_size(s)
		if s <= 0
			raise ArgumentError, "Step size must be greater than 0"
		else
			@@step_size = s
		end
	end
	
	attr_accessor :name, :points
	
	#Default constructor. Usage:
	#<tt>.new(String name, Point *points)</tt>
	def initialize(name,*args, &block)
		@name = name
		@points = args
		if block_given?
			yield self
		end
		@points.sort
	end
	
	# Copy constructor.
	def initialize_copy(other, &block)
		initialize(other.name, other.points, block)
	end
	
	def to_s
		str = "ADHERENCE FUNCTION\n\tPoints:\n"
		@points.each do |point|
			str << "\t#{point}\n"
		end
		return str
	end
	
	# For use with GNUplot
	def to_gplot
		str = ""
		@points.each do |p|
			str << "#{p.x} #{p.y}\n"
		end
		return str
	end
	
	# Returns a new Function with y coordinate multiplied by the given factor.
	# If the new y value is greater than one 1.0 is assigned. This can be used
	# for product-like Mamdani rules.
	# Usage:
	# <tt>.*(Float factor)</tt>
	def *(fl)
		fl = fl.to_f
		unless fl >= 0
			raise ArgumentError, "Argument should be positive"
		end
		new_function = Function.new("#{@name}*#{fl}")
		@points.each do |p|
			new_function.points.push Point.new(p.x, [p.y*fl, 1.0].max)
		end
		return new_function
	end
	
	# Returns a new Function with y coordinate less than given factor.
	# This can be used
	# for max-min-like Mamdani rules.
	# Usage:
	# <tt>.cut_at(Float factor)</tt>
	def cut_at(fl)
		unless fl >= 0 && fl <= 1
			raise ArgumentError, "Argument should be from [0;1]"
		end
		new_function = Function.new("#{@name} MAX #{fl}")
		@points.each do |p|
			puts "#{fl} #{p.y}"
			new_function.points.push Point.new(p.x, [p.y,fl].min)
		end
		return new_function
	end
	
	# Adds points to the function. Usage:
	# <tt>.add(Point *points)</tt>
	def add(*points)
		points.each do |p|
			if @points.include? p
				@points.delete p
			end
		end
		@points.concat points
		@points.sort!
	end
	
	# Removes points from the function. Usage:
	# <tt>.remove(Point *points)</tt>
	def remove(*points)
		points.each do |p|
			@points.delete p
		end
	end
	
	# Calculates function value at x using linear approximation. Function boundaries are from -Infinity to +Infinity.
	# Usage:
	# <tt>.at(Float x)</tt>
	def at(x)
		if @points.first.x >= x
			return @points.first.y
		elsif @points.last.x <= x
			return @points.last.y
		else
			@points.each_index do |i|
				if x >= @points[i].x && x < @points[i+1].x
					dy = @points[i+1].y - @points[i].y
					dx = @points[i+1].x - @points[i].x
					du = (dy/dx)*(x - @points[i].x)
					return @points[i].y + du 
				end
			end
		end
	end
	
	# Method for performing and (t-norm) operation.
	# Usage:
	# <tt>.and(Function f, Float step, Symbol method)
	# <tt>.and(Function f, Float step)
	# <tt>.and(Function f)
	def and(other, step = :auto, method = :auto)
		res = apply_norm(:t, other, step, method)
		if block_given?
			yield res
		end
		return res
	end
	
	# Method for performing or (s-norm) operation.
	# Usage:
	# <tt>.or(Function f, Float step, Symbol method)
	# <tt>.or(Function f, Float step)
	# <tt>.or(Function f)
	def or(other, step = :auto, method = :auto)
		res = apply_norm(:s, other, step, method)
		if block_given?
			yield res
		end
		return res
	end
	
	# Negation. Usage:
	# .not
	def not(&block)
		new_function = Function.new("not #{@name}")
		@points.each_index do |i|
			new_function.points[i] = Point.new(@points[i].x, 1 - @points[i].y)
		end
		if block_given?
			yield new_function
		end
		return new_function
	end
	
	# defuzzification
	def defuzz(method = :auto)
		if(method == :auto)
			unless @@defuzz_method.nil?
				method = @@defuzz_method
			else
				raise ArgumentError, "Specify method, or call Norm::norm_method"
			end
		end
		method(DEFUZZ_METHODS[method]).call(self)
	end
	
	private
	
	# Actually does the norm
	def apply_norm(norm, other, step = :auto, method = :auto)
		if(step == :auto)
			unless @@step_size.nil?
				step = @@step_size
			else
				raise ArgumentError, "Specify step, or call Function::step_size"
			end
		end
		if(method == :auto)
			unless @@norm_method.nil?
				method = @@norm_method
			else
				raise ArgumentError, "Specify method, or call Norm::norm_method"
			end
		end
		if(norm == :t)
			op = "and"
		elsif(norm == :s)
			op = "or"
		else
			raise ArgumentError, "norm for Norm#apply_form must be :t or :s"
		end
		new_function = Function.new("(#{@name} #{op} #{other.name})")
		start_point = [@points.min,other.points.min].min
		stop_point = [@points.max,other.points.max].max
		i = start_point.x
		x = []
		y = []
		while(stop_point.x - i >= 0 - EPSILON)
			x.push i 
			y.push method(NORM_METHODS[method][norm]).call(self.at(i), other.at(i))
			i += step
		end
		x.each_index do |index|
			new_function.points[index] = Point.new(x[index],y[index])
		end
		return new_function
	end
end