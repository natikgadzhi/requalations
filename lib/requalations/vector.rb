module Requalations
  
  # Requalations::Vector
  # Extends default ruby's vector class functionality. 
  # 
  module Vector
    
    ## Instance methods
    
    # Retrieves maximal vector element
    #
    def max 
      self.to_a.max
    end
    
    # Retrieves minimal vector element 
    #
    def min
      self.to_a.min
    end
    
  end
end

# If Vector is defined, include Requalations::Vector into the original one
Vector.send(:include, ::Requalations::Vector ) if defined?(Vector)