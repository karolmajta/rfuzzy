# Class for defining fuzzy domains.
class FuzzyDomain
	attr_reader :adherence_functions
	
	# Constructor.
	def initialize(*functions, &block)
		@adherence_functions = {}
		functions.each do |f|
			unless @adherence_functions.has_key?(f.name)
				@adherence_functions[f.name] = function
			else
				raise ArgumentError, "Lexical variable '#{f.name}' already describes this FuzzyVar!"
			end	
		end
		if block_given?
			yield self
		end
	end
	
	# Allows adding adherence functions with lexical variables describing the domain
	def is_described_by(function, &block)
		if block_given?
			yield function
		end
		unless @adherence_functions.has_key?(function.name)
			@adherence_functions[function.name] = function
		else
			raise ArgumentError, "Lexical variable '#{function.name}' already describes this FuzzyVar!"
		end
	end
	
	# Removes adherence functions and lexical variables
	def is_not_described_by(name)
		@adherence_functions.delete(name)
	end
end