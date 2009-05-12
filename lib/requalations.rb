# Requalations is a toy or study project. 
# That means, it's slow, it contains bugs and there're no guaranties for you.
# If you still want to use it, read this file to understand how it works

# Requelations are using matrices to solve linear equalations like Axi = b, so we need to require matrices
require 'matrix'

# I don't like the idea of using Ruby for some mathematics or other expensive calculations, they are even more expencive with ruby, but
# i like the thought, that all this expencive staff is already rewritten in plain C there. 
require 'mathn'
require 'bigdecimal'
require 'bigdecimal/ludcmp'

# We will require some files from our requalations lib, so let's create a shorthand to requalations lib directory:
requalations_dir = "#{File.dirname(__FILE__)}/requalations"

# After that we need to initialize our own matrix module. 
# Ruby has a build in Matrix class
# But it's not the one we need, it doesn't support some operations, we will define them in our module
# and then just extend native Matrix class.
# We'll include our modules into Matrix and Vector classes
require File.expand_path("#{requalations_dir}/vector.rb")
require File.expand_path("#{requalations_dir}/matrix.rb")

# At this moment, it the right time to require equalation classes. 
require File.expand_path("#{requalations_dir}/linear_equalations.rb")