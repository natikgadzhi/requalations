# Requalations is a toy or study project. 
# That means, it's slow, it contains bugs and there're no guaranties for you.
# If you still want to use it, read this file to understand how it works

# Requelations are using matrices to solve linear equalations like Axi = b, so we need to require matrices
require 'matrix'

# I don't like the idea of using Ruby for some mathematics or other expensive calculations, they are even more expencive with ruby, but
# i like the thought, that all this expencive staff is already rewritten in plain C there. 
require 'mathn'

# After that we need to initialize our own matrix module. 
# Ruby has a build in Matrix class
# But it's not the one we need, it doesn't support some operations, we will define them in our module
# and then just extend native Matrix class.
require File.expand_path("#{File.dirname(__FILE__)}/requalations/matrix.rb")

# At first we extend Ruby Matrix class functionality by extending it and including our Matrix module
Matrix.send( :extend, ::Requalations::Matrix )

# At this moment, it the right time to require equalation classes. 
require File.expand_path("#{File.dirname(__FILE__)}/requalations/linear_equalations.rb")
