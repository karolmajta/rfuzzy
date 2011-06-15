# Trapezoidal adherence function
class Trapezoidal < Function
	#Default constructor. Creates the trapezoidal function. Order of arguments is irrelevant. They will be sorted in ascending order.
	#<tt>.new(Float a, Float b, Float c, Float d)</tt>
	def initialize(name, a, b, c, d)
		p = [a,b,c,d].sort
		super(name, Point.new(p[0],0),Point.new(p[1],1),Point.new(p[2],1),Point.new(p[3],0))
	end
end