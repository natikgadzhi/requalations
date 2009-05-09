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

      ## Initializer
      
      # Initialize a new equalation object
      # Just pass your equalation rows in an array into this
      # And what you get will be separated matrices for coeficients and right side vector.
      # 
      def initialize(equalations)
        # Equalations are expected to be an array. 
        # let's belive it is an array.
        self.equalation_matrix = Matrix.rows( equalations )
        
        # initialize our left and right sides
        
        # To initialize left side of our equalations array, we need to cut the last column from the whole equalation matrix. 
        left_side_columns = self.equalation_matrix.column_vectors
        left_side_columns.delete( left_side_columns.last )

        # After that, we can use this to create lest side matrix
        self.left_side_matrix = Matrix.columns( left_side_columns )
        
        # Right side of an equalation is a one-column matrix, or a vector. 
        # Don't treat it as a row, it's really a column.
        self.right_side_matrix = Matrix.column_vector( self.equalation_matrix.column_vectors.last )
      end
    end
  end
end