module Requalations
  module Linear
    
    # Class Requalation::Linear::Equalation represents a system of linear algebraic equalations 
    # 
    class Equalation
      
      ## Constants 
      
      # These options are used in #solve method.
      DEFAULT_SOLVE_OPTIONS = { :method => :solve_using_LU }
      
      ## attributes
      
      # matrices for misc coeficients
      # actually, i should remove this for other classes not to have access to those private class data.
      attr_accessor :left_side_matrix, :right_side_matrix, :equalation_matrix 
      
      ## Class methods

      ## Initializer
      
      # Initialize a new equalation object
      # Just pass your equalation rows in an array into this
      # And what you get will be separated matrices for coeficients and right side vector.
      # 
      def initialize(equalations)
        # Equalations are expected to be an array. 
        # let's belive it is an array.
        @equalation_matrix = Matrix.rows( equalations )
        
        # initialize our left and right sides
        
        # To initialize left side of our equalations array, we need to cut the last column from the whole equalation matrix. 
        left_side_columns = @equalation_matrix.column_vectors
        left_side_columns.delete( left_side_columns.last )

        # After that, we can use this to create lest side matrix
        @left_side_matrix = Matrix.columns( left_side_columns )
        
        # Right side of an equalation is a one-column matrix, or a vector. 
        # Don't treat it as a row, it's really a column.
        @right_side_matrix = Matrix.column_vector( @equalation_matrix.column_vectors.last )
      end
      
      ## Instance methods
      
      # Solve the equalation. 
      # 
      def solve(options = {})
        # Merge default options with what we've got passed here 
        options = DEFAULT_SOLVE_OPTIONS.merge( options )
        
        # By now, just send to self method, which need to be executed to solve
        send options[:method]
      end
      
      ## Private instance methods
      private
        
      # Solves the equalation using LU method. 
      # 
      def solve_using_LU
        
      end
      
    end
  end
end