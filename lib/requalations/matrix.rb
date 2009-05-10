module Requalations
  
  # Requalations matrix module
  # Defines additional matrix methods and operations
  #
  module Matrix
    
    # Attribut reareds for p, l and u matrices in LPU decomposition
    attr_reader :l, :u, :p
    
    # Retrieves LU decomposition matrices for the matrix. 
    # 
    def lu
      # We will use the matrix size in a plenty of places here, so 
      # we want to create a shorhand accessor. 
      n = self.column_size
      
      # p matrix — matrix.identity by default. 
      p = Matrix.identity( n )
      
      # Create blank l and u matrices:
      
      
      
      # initialize arrays for new matrices
      rows_for_l = []
      rows_for_u = []
      
    end
    
  end
end

# If Matrix is already initialized, include Requalations::Matrix into the original one
Matrix.send( :include, ::Requalations::Matrix ) if defined?( Matrix )