# Require everything we need to boot here. 
# After that just require myself and all my staff. 
#

# We're using linalg to work with linear algebra equalations systems, matrices and other staff. 
require 'linalg'

# Require our linear systems 
require File.expand_path("#{File.dirname(__FILE__)}/linear/system")