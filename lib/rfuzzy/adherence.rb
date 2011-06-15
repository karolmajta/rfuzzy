# Adherence. Basically it's a Float in range [0;1] allowing norm operations.
class Adherence
	include Norm
	
	# Constructor. Usage
	# <tt>.new(Float value)</tt>
	# Value must be [0;1]
	def initialize(val)
		if val < 0 || val > 1
			raise ArgumentError, "Adherence must be in [0;1]"
		end
		@adh = val
	end
	
	def to_f
		return @adh
	end
	
	# Performs t-norm on itself and other. Usage:
	# <tt>.and(Adherence other, Symbol method)
	# <tt>.and(Adherence other)
	def and(other, method = :auto)
		if(method == :auto)
			unless @@norm_method.nil?
				method = @@norm_method
			else
				raise ArgumentError, "Specify method, or call Norm::norm_method"
			end
		end
		return Adherence.new(self.method(NORM_METHODS[method][:t]).call(self.to_f, other.to_f))
	end
	
	# Performs s-norm on itself and other. Usage:
	# <tt>.or(Adherence other, Symbol method)
	# <tt>.or(Adherence other)
	def or(other, method = :auto)
		if(method == :auto)
			unless @@norm_method.nil?
				method = @@norm_method
			else
				raise ArgumentError, "Specify method, or call Norm::norm_method"
			end
		end
		return Adherence.new(self.method(NORM_METHODS[method][:s]).call(self.to_f, other.to_f))
	end
	
	# Performs negation.
	def not
		return Adherence.new(1 - @value)
	end
end