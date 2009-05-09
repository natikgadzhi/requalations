module Requalations
  module Linear
    
    # Class Requalation::Linear::System represents a system of linear algebraic equalations 
    # 
    class System
      
      ## attributes
      
      # coefficients matrices
      attr_accessor :equalation_coeficients, :results_vector, :source_matrix
      
      
      ## Class methods
      
      # Creates an equalations system from a matrix with coeficients 
      # and the resulting vector. 
      # 
      def self.from_matrix( matrix )
        # B is copied before A, cause A calculation will modify "matrix" argument
        b = matrix.collect{ |row| row.last }
        a = matrix.collect{ |row| row.delete(row.last); row }
        
        # then pass the parameters into a normal initialize method
        system = Requalations::Linear::System::new( a, b )
        system
      end
      
      ## initialize
      
      # Creates a new linear equalations system from matrix of coeficients 
      # 
      # a params is a coeficients matrix 
      # b parameter is vector of the results
      # ax = b 
      # 
      def initialize( a, b )
        # Store the source data forst. 
        # Create matrices for coeficients in front of all the variables 
        # Then store resulting vector 
        @equalation_coeficients = ::Linalg::DMatrix.rows(a)
        @results_vector = ::Linalg::DMatrix.rows( b.collect{ |coeficient| [coeficient]} )
        
        rows = a.collect{ |row| row << b.shift; row }
        @source_matrix = ::Linalg::DMatrix.rows(a)
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