# Used for representing expert system of any kind
class FuzzySystem
	@domains
	@inputs
	@outputs
	@defaults
	@rules
	
	# Constructor - yields self. Usage:
	# <tt>.new()</tt>
	def initialize
		@domains = {}
		@inputs = {}
		@outputs = {}
		@defaults = {}
		@rules = []
		if block_given?
			yield self
		end
	end
	
	# Declare an input in the system. This will result in creating
	# i_[name] and i_[name]= used for getting and setting the values
	# for this input. Usage:
	# <tt>.input(String name, FuzzyDomain domain)</tt>
	def  input(name, domain)
		@domains[name] = domain
		
		body = Proc.new do
			@inputs[name]
		end
		self.class.send(:define_method, "i_#{name}", body)
		
		body = Proc.new do |val|
			@inputs[name] = val
		end
		self.class.send(:define_method, "i_#{name}=", body)
	end
	
	# Declare an an output in the system. This will result in creating
	# o_[name] and o_[name]= used for getting and setting the values
	# for this output. Usage:
	# <tt>.output(String name, FuzzyDomain domain)</tt>
	def output(name, default = nil)
		@defaults[name] = default
		
		body = Proc.new do
			unless @outputs[name].nil?
				@outputs[name]
			else
				@defaults[name]
			end
		end
		self.class.send(:define_method, "o_#{name}", body)
		
		body = Proc.new do |val|
			@outputs[name] = val
		end
		self.class.send(:define_method, "o_#{name}=", body)
	end
	
	# Used for adding rules to the system. Usage:
	# <tt>.rule(Proc antecendent, Proc consequent)</tt>
	def rule(ant, cons)
		r = Rule.new(ant, cons)
		@rules.push r
		return @rules[@rules.length-1]
	end
	
	# Used for pushing input into the system. Takes a dict in which
	# keys are declared input names, and values are current values (FuzzyVariables).
	# This method performs a check if given data matches the one declared for the system.
	# Usage:
	# <tt>.inject(Hash inputs)</tt>
	def inject(dict)
		unless dict.keys == @domains.keys
			raise ArgumentError, 'Input dictionary does not match the system inputs'
		end
		dict.each do |key, value|
			if value.respond_to? :domain=
				value.domain = @domains[key]
			end
		end
		@inputs = dict
	end
	
	# Returns a dict of all calculated outputs.
	# Usage:
	# <tt>.eject()</tt>
	def eject
		return @outputs
	end
	
	# Resets all outputs. Usage:
	# <tt>.reset()</tt>
	def reset
		@outputs = {}
	end
	
	# Calls .apply on every rule in the system in order they were declared. Usage:
	# <tt>.process()</tt>
	def	process
		@rules.each do |r|
			r.apply
		end
	end
end