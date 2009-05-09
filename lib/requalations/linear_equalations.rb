module Requalations
  module Linear
    
    # Class Requalation::Linear::Equalation represents a system of linear algebraic equalations 
    # 
    class Equalation
      
      ## attributes
      
      # matrices for misc coeficients
      # actually, i should remove this for other classes not to have access to those private class data.
      attr_accessor :left_side_matrix, :right_side_matrix, :equalation_matrix 
      
      ## Class methods
      
      
      ## initialize
      
      # Initialize a new equalation object
      # 
      def initialize( a, b )
        
      end
      
      ## Instance methods
      
      # Solves the equalation using native DMatrix#solve
      # 
      def solve
        return ::Linalg::DMatrix.solve( @equalation_coeficients, @results_vector)
      end
      
      # Retrieves equalation matrix determinant
      # a shorthand to @eaualation_coeficients.det
      #
      def det
        @equalation_coeficients.det
      end
    end
  end
end