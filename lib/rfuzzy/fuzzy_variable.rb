# Represents fuzzy value belonging to a specific domain. Calculates the adherence on demand.
class FuzzyVariable
	include Norm
	
	attr_accessor :value, :domain
	
	# Constructor. Usage
	# <tt>.new(Float value)</tt>
	def initialize(val, &block)
		@value = val.to_f
		if block_given?
			yield self
		end
	end
	
	def to_f
		return @value
	end
	
	# returns new FuzzyVariable with value multiplied by float
	# <tt>.*(float)</tt>
	def *(float)
		return FuzzyVariable.new(@value*float.to_f, @domain)
	end
	
	# Calculates the adherence of variable. Usage:
	# <tt>.is(String lex_var, Symbol method)</tt>
	# <tt>.is(String lex_var)
	def is(lex_var, method = :auto)
		if(method == :auto)
			unless @@norm_method.nil?
				method = @@norm_method
			else
				raise ArgumentError, "Specify method, or call Norm::norm_method"
			end
		end
		if @domain.adherence_functions.has_key? lex_var
			return Adherence.new(@domain.adherence_functions[lex_var].at(@value))
		else
			raise ArgumentError, "Specified adjective '#{lex_var}' does not belong to variable's domain"
		end
	end
	
	# Calculates negation of variables adherence. Usage - same as .is
	def is_not(lex_var, method = :auto)
		if(method == :auto)
			unless @@norm_method.nil?
				method = @@norm_method
			else
				raise ArgumentError, "Specify method, or call Norm::norm_method"
			end
		end
		if @domain.adherence_functions.has_key? lex_var
			return Adherence.new(1-@domain.adherence_functions[lex_var].at(@value))
		else
			raise ArgumentError, "Specified adjective does not belong to variable's domain"
		end
	end
end