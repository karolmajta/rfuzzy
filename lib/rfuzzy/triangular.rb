# Triangular adherence function
class Triangular < Function
	#Default constructor. Creates the trapezoidal function. Order of arguments is irrelevant. They will be sorted in ascending order.
	#<tt>.new(Float a, Float b, Float c)</tt>
	def initialize(name, a, b, c)
		p = [a,b,c].sort
		super(name, Point.new(p[0],0),Point.new(p[1],1),Point.new(p[2],0))
	end
end