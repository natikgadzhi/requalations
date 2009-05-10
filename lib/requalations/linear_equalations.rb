module Requalations
  module Linear
    
    # Class Requalation::Linear::Equalation represents a system of linear algebraic equalations 
    # 
    class Equalation
      
      ## Constants 
      
      # These options are used in #solve method.
      DEFAULT_SOLVE_OPTIONS = { :with => :LU }
      
      ## attributes
      
      # matrices for misc coeficients
      # actually, i should remove this for other classes not to have access to those private class data.
      # removed attr_accessor  
      
      ## Class methods

      ## Initializer
      
      # Initialize a new equalation object
      # Just pass your equalation rows in an array into this
      # And what you get will be separated matrices for coeficients and right side vector.
      #
      # equalations is expected to be an array of arrays with numbers. Not vectors, or matrices, of any kind of. 
      # 
      def initialize(equalations)
        # Equalations are expected to be an array. 
        # let's belive it is an array.
        @equalation_matrix = ::Matrix.rows( equalations )
        
        # initialize our left and right sides
        
        # To initialize left side of our equalations array, we need to cut the last column from the whole equalation matrix. 
        left_side_columns = @equalation_matrix.column_vectors
        left_side_columns.delete( left_side_columns.last )

        # After that, we can use this to create lest side matrix
        @left_side_matrix = ::Matrix.columns( left_side_columns )
        
        # Right side of an equalation is a one-column matrix, or a vector. 
        # Don't treat it as a row, it's really a column.
        @right_side_vector = ::Vector.elements( @equalation_matrix.column_vectors.last.to_a.flatten )
      end
      
      ## Instance methods
      
      # Solve the equalation. 
      # 
      def solve(options = {})
        # Merge default options with what we've got passed here 
        options = DEFAULT_SOLVE_OPTIONS.merge( options )
        
        # By now, just send to self method, which need to be executed to solve
        send "solve_using_#{options[:with]}".to_sym
      end
      
      
      
      ## Private instance methods
      private
        
      # Solves the equalation using LU method. 
      # 
      def solve_using_LU
        # We will use our C matrix, which should contain U + L - E 
        @left_side_matrix.lu if @left_side_matrix.c.nil?

        # push matrix size to n, so i can use it later in cycles
        n = @left_side_matrix.column_size
        
        # empty array for the solution
        @solution_vector = []
        for i in 0...n do
          @solution_vector[i] = 0
        end
        
        # Implementation. Oh god, i'm tired ^^ 
        for i in 0...n do
          t = 0;
          for j in 0...i do
            t = t + @left_side_matrix.c[i,j]*@solution_vector[j]
          end
          @solution_vector[i] = @right_side_vector[@left_side_matrix.p_vector[i]] - t
        end
        
        (n-1).downto(0) do |i|
          t = 0
          for j in (i + 1)...n do
            t = t + @left_side_matrix.c[i,j]*@solution_vector[j]
          end
          @solution_vector[i] = ( @solution_vector[i] - t )/@left_side_matrix.c[i,i]
        end
        
        # Pass the results into a vector and return them
        ::Vector.elements(@solution_vector)
      end
      
      
      # Use splines method to solve linear equalations system
      # With 3-diagonal matrix of equalation at the left side 
      # 
      def solve_using_sweep
        # First thing to do is setting p and q coeficients in 
        # zeros
        p = []
        q = []
        @solution_vector = []
        
        # P1 and Q1 depends only on left_matrix, so 
        p[1] = @left_side_matrix[0,1] / -@left_side_matrix[0,0] 
        q[1] = @right_side_vector[0] / @left_side_matrix[0,0]
        
        n = @left_side_matrix.column_size  
        
        # Direct flow of sweep method
        for i in 2...n do
          puts "direct<br>"
          p[i] = @left_side_matrix[i-1,i] / ( -@left_side_matrix[i-1, i-1] - @left_side_matrix[i-1, i-2]*p[i-1] ) 
          q[i] = ( @left_side_matrix[i-1,i-2]*q[i-1] - @right_side_vector[i-1] ) / 
            ( -@left_side_matrix[i-1,i-1] - @left_side_matrix[i-1, i-2]*p[i-1] )
        end
        
        @solution_vector[n-1] = q[n-1]
        
        # Reverse
        (n-2).downto(0) do |i|
          @solution_vector[i] = p[i+1]*@solution_vector[i+1] + q[i+1]
          puts "reverse: solution#{i} => #{@solution_vector[i]}<br>"
        end
        
        # Pass the results into a vector and return them
        ::Vector.elements(@solution_vector)
      end
      
    end
  end
end