# 
# Provides Matrix#qr method
# which retrieves q and r matrices using givens rotations algorythm. 
# http://en.wikipedia.org/wiki/QR_decomposition
#
# Also provides Matrix#eigenvalues_using_qr, which returns matrix eigenvalues
# calculated from q and r matrices. 
# 
# This file is included by ./lib/matrix.rb and is autoloaded, if requalations gem is loaded, 
# so there's no need to require it explicitly. 
# 
# (c) 2009 Nat Gadgibalaev <iam@railsmaniac.com> 
# http://github.com/railsmaniac
# See LICENSE for more information on licensing  
# 
module Requalations
  module Matrix
    # Decompositions module stores all the decomposition methods
    module Decompositions
      # QR decomposition and friends
      module QR
        
        # Retrieves Q and R matrices using Householder method
        # 
        def qr
          # matrix size shorthand
          n = column_size
          # iterations counter
          iterations_count = 0
          
          # This is what we're going to return # 
          # Q matrix
          q_matrix = ::Matrix.identity(n)
          # R matrix
          r_matrix = self.clone
          
          # This is our internal calculation staff
          # We will calculate householder matrix
          h_matrix = []
          
          # V vector for H matrix calculation.
          v_vector = []
          
          # Once more here. 
          # Feel free to drop me a line on email or github. 
          
          # Let's start iterating.
          # The simple explanation to this: 
          # We want to find Q and R in A = Q*R.
          # We know, that Q * Q.t = E and R is upper-triagonal matrix. 
          # Method will mutate the matrix into upper triangonal R matrix 
          # And the Q matrix can be found as a multiplication result between all the H* matrices. 
          # See more details on wiki page here http://en.wikipedia.org/wiki/QR_decomposition
          
          # i variable is an integer, it's column number
          for i in 0...n do
            
            # Update iteration data and stats
            iterations_count += 1
            v_vector = []
            
            # On i-th iteration we need to pass a Ith column into V vector generator 
            for k in 0...n do
              v_vector[k] = [0] if k < i  # user zeros on second + iteration for first I elements of V vector
              
              # Ith element in V is kinda complecated: 
              if k == i
                sign = r_matrix[k,k] < 0 ? -1 : 1
                norm = 0
                for j in k...n
                  norm = norm + r_matrix[j,i] ** 2
                end
                norm = norm ** 0.5
                
                v_vector[k] = [ r_matrix[k,k] + sign * norm ] 
              end
              
              v_vector[k] = [ r_matrix[k,i] ]
            end
            v_vector = ::Matrix.columns(v_vector).t
            
            # Now let's get H matrix 
            multiplier = ( v_vector.t * v_vector )
            multiplier = 2 / multiplier[0,0]
            h_matrix = ::Matrix.identity(n) - multiplier * ( v_vector * v_vector.t )
            
            # this step is done. 
            # R is one step closer. 
            # And q is too 
            r_matrix = h_matrix * r_matrix
            q_matrix *= h_matrix         
            
            puts "#{iterations_count}: #{r_matrix}<br><br>"
          end 
        
        # return values
        [q_matrix, r_matrix, iterations_count]  
        end
      end
    end
  end
end



# Include self into the base matrix class
::Matrix.send :include, Requalations::Matrix::Decompositions::QR if defined?(Matrix)