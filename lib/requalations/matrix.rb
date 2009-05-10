module Requalations
  
  # Requalations matrix module
  # Defines additional matrix methods and operations
  #
  module Matrix
    
    # Attribut reareds for p, l and u matrices in LPU decomposition
    attr_reader :l, :u, :p, :c
    
    # Retrieves LU decomposition matrices for the matrix. 
    # 
    def lu
      # We will use the matrix size in a plenty of places here, so 
      # we want to create a shorhand accessor. 
      # We want to iterate through the matrix elements, which are started from index 0, not 1, so
      # we need to exclude 1 from elements count not to exceed matrix boundaries.
      n = self.column_size - 1
      
      # p matrix — matrix.identity by default. 
      @p = Matrix.identity( n )
      
      # C matrix will contain l + u - identity
      @c = self.clone
      
      # Search for pivot elements
      # For that, we need to iterate through the columns
      
      # Initialize column and row indeces 
      column_index = 0;
      row_index = 0;
      
      # Iterate throught columns
      for column_index in 0..n do 
        # create a shorthand for current column
        column = self.column(column_index)
        
        # pass 0 to pivot value and index
        pivot_value = 0.0
        # index 0 would be a valid index, so we set it to -1 to know, if we'll find a valid pivot
        pivot_index = -1 
        
        # iterate though the column under the main diagonal
        for row_index in column_index..n
          # Find max value there
          if @c[row_index, column_index] > pivot_value
            pivot_value = @c[row_index, column_index]
            pivot_index = row_index
          end
        end
        
      end
      
      
      # initialize arrays for new matrices
      rows_for_l = []
      rows_for_u = []
      
    end
    
  end
end

# If Matrix is already initialized, include Requalations::Matrix into the original one
Matrix.send( :include, ::Requalations::Matrix ) if defined?( Matrix )