# 
# Provides #lu method, decomposes matrix into L*U*P matrices. 
# 
# (c) 2009 Nat Gadgibalaev <iam@railsmaniac.com> 
# http://github.com/railsmaniac
# See LICENSE for more information on licensing  
# 
module Requalations
  module Matrix
    # Decompositions module stores all the decomposition methods
    module Decompositions
      # LU decompositions
      module LU
        
        ## Accessors & properties
        # permutation vector accessor should be done as a separate method, sinse it has some logic in it. 
        attr_reader :lower_triangular, :upper_triangular, :permutation_matrix, :lu_decomposition_matrix
        
        # Returns true, if permutation_vector is already created. 
        # 
        def has_permutation_vector?
          @permutation_vector.kind_of?(Vector)
        end
        
        # Retrieves permutation_vector
        # 
        def permutation_vector
          # If we already have this calculation done - return
          if has_permutation_vector?
            @permutation_vector
          else
            # create a blank vector for permutation
            @permutation_vector = ::Vector.blank(n)
            for i in 0...n do 
              for j in 0...n do 
                # For each column, find non-zero element and copy it's number into the vector
                @permutation_vector[j] = i if @permutation_matrix[i,j].eql?(1)
              end
            end
            return @permutation_vector    
          end
        end
        
        ## Class methods
        
        # Returns true, if LU decomposition is already done
        # 
        def lu_decomposed?
          @already_lu_decomposed == true && !@lower_triangular.nil? && 
            !@upper_triangular.nil? && !@permutation_matrix.nil? && !@lu_decomposition_matrix.nil?
        end
        
        # perform LU decomposition on the matrix
        # TODO: Calculate permucation_vector 
        # 
        # lu_decomposition_matix = upper_triangular + lower_triangular + identity 
        # permutation_matrix - matrix of pivot point swappings 
        # 
        # 
        def lu_decompose
          # If we've already done that calculation - just use it! 
          return [@lower_triangular, @upper_triangular, @permutation_matrix] if lu_decomposed? 
          
          # Check, if the matrix is singular.
          raise StandardError.new("Equalation matrix can't be singular") if self.singular?
          
          # Initialize the permutation matrix. It's identity by default, cuz we didn't perform any swappings for now.
          @permutation_matrix = ::Matrix.identity(n)

          # This will be the decomposition = l + u - E 
          @lu_decomposition_matrix = self.clone

          # Search for pivot elements
          # For that, we need to iterate through the columns and find the biggest elements in each column. 
          # If the element will not lie on the diagonal, we will swap rows, so it will be there. 
          # 

          # Iterate throught columns
          for column_index in 0...n do 
            # create a shorthand for current column
            column = @lu_decomposition_matrix.column(column_index)

            # pass 0 to pivot value and index
            pivot_value = 0.0
            # index 0 would be a valid index, so we set it to -1 to know, if we'll find a valid pivot
            pivot_index = -1

            # get pivot value and index from the column
            pivot_value, pivot_index = column.slice(column_index...n).absolute_max_value_and_index

            # We've retrieved pivot position in the column slice! 
            # So we need to add slice prefix, that is column_index to the pivot_index
            pivot_index += column_index 

            # Swap column_index and pivotal_index rows in the identity matrix
            # by this we're gonna get premutation matrix
            # And in c matrixm, which will be our decomposition matrix 
            @lu_decomposition_matrix.swap_rows!(pivot_index, column_index)
            # Store this swap in the permutation matrix
            @permutation_matrix.swap_rows!(pivot_index, column_index)

            # Recalculate elements of decomposition
            # This is similar to Gauss algorythm. 
            for j in (column_index + 1)...n do
              @lu_decomposition_matrix[j, column_index] = @lu_decomposition_matrix[j, column_index] / @lu_decomposition_matrix[column_index, column_index]
              for k in ( column_index + 1)...n do
                @lu_decomposition_matrix[j,k] = @lu_decomposition_matrix[j,k] - @lu_decomposition_matrix[j,column_index] * @lu_decomposition_matrix[column_index,k]
              end
            end

          end

          # We have our decomposition in lu_decomposition matrix = L + U - E. 
          # We know for sure, lower_triangular matrix, which is L in the upper equalation, has 1 on each diagonal element, so lets place 1 there! 
          @lower_triangular = ::Matrix.identity( n )
          
          # Then we will copy data from lower-left corner of lu_decomposition_matrix to lower_triangular
          # We can do it, sinse upper_triangular contains only upper-right elements.
          for i in 0...n do
            for j in 0...i
              @lower_triangular[i,j] = @lu_decomposition_matrix[i,j]
            end
          end
          
          # Now let's use the equalation c = l + u - e to find upper_triangular matrix
          @upper_triangular = @lu_decomposition_matrix - @lower_triangular + ::Matrix.identity( n )

          # That's it! we can return the values now.
          [@lower_triangular, @upper_triangular, @permutation_matrix]
        end
        
        # Retrieves determinant using LU decomposition
        # TODO: implement determinant using LU decomp. 
        def determinant_using_lu_decomposition
          # ensure we have the decomposition
          lu_decompose unless lu_decomposed?
          # return the determinant
          @lower_triangular.determinant * @upper_triangular.determinant
        end
        
        # Retrieves inverser matrix using LU decomposition 
        # TODO: implement inversion using lu decomp. 
        # 
        def inverse_using_lu_decomposition
          # for(int k = n-1; k >= 0; k--) {
          #               X[ k ][ k ] = 1;
          #               for( int j = n-1; j > k; j--) X[ k ][ k ] -= C[ k ][ j ]*X[ j ][ k ];
          #               X[ k ][ k ] /= C[ k ][ k ];
          #               for( int i = k-1; i >= 0; i-- ) {
          #                   for( int j = n-1; j > i; j-- ) {
          #                       X[ i ][ k ] -= C[ i ][ j ]*X[ j ][ k ];
          #                       X[ k ][ i ] -= C[ j ][ i ]*X[ k ][ j ];
          #                   }
          #                   X[ i ][ k ] /= C[ i ][ i ];
          #               }
          #           }
          #           X = X*P;
          #           return( X );
          
          # Ensure that we have decomposition done
          lu_decompose unless lu_decomposed? 
          
          # Create an identity matrix. This will be our inverse matrix soon.
          @inverse_matrix_from_lu = ::Matrix.identity(n)
          
          (n-1).downto(0) do |k|
            (n-1).downto(k + 1) do |j|
              @inverse_matrix_from_lu[k,k] -= @lu_decomposition_matrix[k,j] * @inverse_matrix_from_lu[j,k]
            end
            @inverse_matrix_from_lu[k,k] /= @lu_decomposition_matrix[k,k]
            (k-1).downto(0) do |i|
              (n-1).downto(i + 1) do |j|
                @inverse_matrix_from_lu[i,k] -= @lu_decomposition_matrix[i,j] * @inverse_matrix_from_lu[j,k]
                @inverse_matrix_from_lu[k,i] -= @lu_decomposition_matrix[j,i] * @inverse_matrix_from_lu[k,j]
              end
              @inverse_matrix_from_lu[i,k] /= @lu_decomposition_matrix[i,i]
            end
          end
          
          @inverse_matrix_from_lu *= @permutation_matrix 
          @inverse_matrix_from_lu
        end
        
      end
    end
  end
end



# Include self into the base matrix class
::Matrix.send :include, Requalations::Matrix::Decompositions::LU if defined?(Matrix)