# Represents the Rule for FuzzySystem where both antescendent and consequent are Proc objects
class Rule
	@antecendent
	@consequent
	
	# Usage:
	# <tt>.new(Proc antecentent, Proc consequent)</tt>
	def initialize(ant, cons)
		@antecendent = ant
		@consequent = cons
	end
	
	# Calls antecentent and then calls consequent
	# passing the result from antecendent to consequent.
	# In most cases the passed value is Adherence.
	# Usage:
	# <tt>.apply()</tt>
	def apply
		@consequent.call(@antecendent.call)
	end
end