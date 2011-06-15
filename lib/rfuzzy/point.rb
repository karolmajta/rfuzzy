# Point used for adherence functions.
# Should not be thought of as a point-in-space.
class Point
	include Comparable

	attr_accessor :x, :y
	# Constructor. Usage:
	# <tt>.new(Float x, Float y)</tt>
	# y must be [0;1]
	def initialize(x, y)
		@x = x.to_f
		if y < 0 || y > 1
			raise RangeError, "Function values for fuzzy sets must be from [0;1]", caller
		end
		@y = y.to_f
	end
	
	def to_s
		return "(#{@x},#{@y})"
	end
	
	# Convenient for use with GNUplot.
	def to_gplot
		return "#{@x} #{@y}\n"
	end
	
	# This is here only for sorting, should not be used for 'real' comparsion
	def <=>(other)
		@x <=> other.x
	end
end