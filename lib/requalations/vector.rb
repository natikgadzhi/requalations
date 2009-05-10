module Requalations
  
  # Requalations::Vector
  # Extends default ruby's vector class functionality. 
  # 
  module Vector
    
    ## Instance methods
    
    # Retrieves maximal vector element
    #
    def max 
      if max_element.kind_of? Array
        max_element.first
      else
        max_element
      end
    end
    
    # Retrieves maximum element index
    #
    def max_index
      self.to_a.index(max_element)
    end
    
    # Retrieves minimal vector element 
    #
    def min
      if min_element.kind_of? Array
        min_element.first
      else
        min_element
      end
    end
    
    # Retrieves minimal element index
    #
    def min_index
      self.to_a.index(min_element)
    end
    
    # Retrieves a new vector which is a slice of the vector from A to B index
    def slice( range)
      ::Vector.elements( self.to_a.slice(range) )
    end
    
    ## Private instance methods
    private
    
    # Retrieves max element of vector, whenever it's a number or an array (29 or [29])
    # 
    def max_element
      self.to_a.max
    end
    
    # Retrieves minimal element index 
    # 
    def min_element
      self.to_a.min
    end
    
  end
end

# If Vector is defined, include Requalations::Vector into the original one
Vector.send(:include, ::Requalations::Vector ) if defined?(Vector)