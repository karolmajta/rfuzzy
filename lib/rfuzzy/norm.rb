# Module with t-norms and s-norms
module Norm
	NORM_METHODS = {
		:maxmin => {:t => :t_norm_max_min, :s => :s_norm_max_min},
		:prob => {:t => :t_norm_prob, :s => :s_norm_prob}
	}
	
	@@norm_method = nil
	
	# Sets the method for norms. Valid methods are keys in <em>NORM_METHODS</em>
	def Norm.norm_method(m)
		if NORM_METHODS.has_key?(m)
			@@norm_method = m
		else
			sm = ""
			NORM_METHODS.each_key do |k|
				sm << "#{k} "
			end
			raise ArgumentError, "method #{m} is not supported for t-norms and s-norms\nSupported methods: #{sm}"
		end
	end
	
	# Max/min t-norm
	def t_norm_max_min(x,y)
		return [x,y].min
	end
	
	# Max/min s-norm
	def s_norm_max_min(x,y)
		return [x,y].max
	end
	
	# Probablistic t-norm
	def t_norm_prob(x,y)
		return x*y
	end
	
	# Probablistic s-norm
	def s_norm_prob(x,y)
		return x+y-x*y
	end
end