#get current dir
require 'pathname'
current_dir = Pathname.new(File.dirname(__FILE__))
# mixins
require current_dir + "rfuzzy/norm"
require current_dir + "rfuzzy/defuzz"
# classes
require current_dir + "rfuzzy/point"
require current_dir + "rfuzzy/function"
require current_dir + "rfuzzy/adherence"
require current_dir + "rfuzzy/fuzzy_domain"
require current_dir + "rfuzzy/fuzzy_variable"
require current_dir + "rfuzzy/rule"
require current_dir + "rfuzzy/fuzzy_system"
# helper classes
require current_dir + "rfuzzy/trapezoidal"
require current_dir + "rfuzzy/triangular"