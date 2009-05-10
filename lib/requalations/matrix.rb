module Requalations
  
  # Requalations matrix module
  # Defines additional matrix methods and operations
  #
  module Matrix
    
    # Attribut reareds for p, l and u matrices in LPU decomposition
    attr_reader :l, :u, :p, :c
    
    # Swaps two rows
    #
    def swap_rows!( from, to)
      to_row = row(to)
      
      set_row( to, row(from))
      set_row( from, to_row)
    end
    
    # Allows you to set matrix elements one by one
    # 
    def []=(row, column, value)
      @rows[row][column] = value
    end
    
    # These two methods are equal to []=
    #  
    alias_method :set_element, :[]=
    alias_method :set_component, :[]= 
    
    # Retrieves LU decomposition matrices for the matrix. 
    # 
    def lu
      
      # Check, if the matrix is singular.
      raise StandardError.new("Equalation matrix can't be singular") if self.singular?
      
      # We will use the matrix size in a plenty of places here, so 
      # we want to create a shorhand accessor. 
      # We want to iterate through the matrix elements, which are started from index 0, not 1, so
      # we need to exclude 1 from elements count not to exceed matrix boundaries.
      n = self.column_size
      
      # p matrix — matrix.identity by default. 
      @p = ::Matrix.identity(n)
      
      # C matrix will contain l + u - identity
      @c = self.clone
      
      # Search for pivot elements
      # For that, we need to iterate through the columns
      
      # Iterate throught columns
      for column_index in 0...n do 
        # create a shorthand for current column
        column = self.column(column_index)
        
        # pass 0 to pivot value and index
        pivot_value = 0.0
        # index 0 would be a valid index, so we set it to -1 to know, if we'll find a valid pivot
        pivot_index = -1
        
        # get pivot value and index from the column
        pivot_value, pivot_index = column.slice(column_index...n).absolute_max_value_and_index
        
        # We've retrieved pivot position in the column slice! 
        # So we need to add slice prefix, that is column_index to the pivot_index
        pivot_index += column_index 
        # puts " -- in the column #{column}: "
        # puts "pivot: #{pivot_value} at #{column_index}:#{pivot_index}"
        # puts "but actual element there is #{column[pivot_index]} <br>"
        
        # Swap column_index and pivotal_index rows in the identity matrix
        # by this we're gonna get premutation matrix
        # And in c matrixm, which will be our decomposition matrix 
        @c.swap_rows!(pivot_index, column_index)
        @p.swap_rows!(pivot_index, column_index)
        
        # Recalculate elements of c
        for j in (column_index + 1)...n do
          @c[j, column_index] = @c[j, column_index] / @c[column_index, column_index]
          for k in ( column_index + 1)...n do
            @c[j,k] = @c[j,k] - @c[j,column_index] * @c[column_index,k]
          end
        end
        
      end
      
      # After all the calculations, we have c matrix with L + U - E  
      
      # c = L + U  And we know, that L is lower-triangular with 1 in the diagonal, so:
      @l = ::Matrix.identity( n )
      for i in 0...n do
        for j in 0...i
          @l[i,j] = @c[i,j]
        end
      end
      
      @u = @c - @l + ::Matrix.identity( n )
      
      [@l, @u, @p]
    end
    
    ## Private instance methods
    private
    
    # Sets row to supplied vector
    #
    def set_row( row_index, vector )
      @rows[row_index] = vector.to_a
    end

  end
end

# If Matrix is already initialized, include Requalations::Matrix into the original one
Matrix.send( :include, ::Requalations::Matrix ) if defined?( Matrix )
Matrix.send( :include, LUSolve) if defined?( Matrix )