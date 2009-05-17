module Requalations
  module NonLinear
    
    ## A set uf multiple nonlinear equalations
    # 
    class EqualationSet
      
      ## Settings 
      # Default init options like minimal and maximal argument value etc
      # DEFAULT_INITIALIZE_OPTIONS = { :target_value => 0 }.freeze
      # Default solve options like which method use to solve 
      DEFAULT_SOLVE_OPTIONS = { :method => :iterations, :default_argument_value => 0, :eps => 0.0001, :max_iterations => 2000}.freeze
      
      # Initialize a new equalation. 
      # Create an empty equalations and variables array.
      # default_variables - array of default variables values
      # 
      def initialize( default_variables = [])
        @equalations = []
        @variables = default_variables
        @iterations_count = 0
        @derivatives = []
      end
      
      ## Instance methods
      # Solve the equalation with the folowing options
      # 
      def solve( options = {})
        options = DEFAULT_SOLVE_OPTIONS.merge(options)
        
        send "solve_using_#{options[:method]}", options
      end
      
      # add an equalation to this set
      def add( &block )
        @equalations << block if block_given?
        @derivatives << []
      end
      
      def add_derivative( function_number, variable_number, &block)
        @derivatites[function_number] = [] if @derivatives[function_number].nil?
        @derivatives[function_number][variable_number] = block
      end
      
      
      private 
      
      def solve_using_iterations( options = {} )
        options = DEFAULT_SOLVE_OPTIONS.merge(options)
        current_iteration_values = @variables
        @iterations_count = 0

        begin
          delta = 0
          @iterations_count += 1
          previous_iteration_values = current_iteration_values.clone

          for i in 0...@equalations.size do
            current_iteration_values[i] = @equalations[i].call(previous_iteration_values)
          end

          for i in 0...@equalations.size do 
            delta = [delta, (current_iteration_values[i] - previous_iteration_values[i]).abs].max
          end

        end while delta > options[:eps] && @iterations_count < options[:max_iterations]

        return [current_iteration_values, @iterations_count]
      end
      
      # Solve the system using 
      # 
      def solve_using_newton( options = {})
        options = DEFAULT_SOLVE_OPTIONS.merge(options)
        current_iteration_values = @variables
        @iterations_count = 0
        
        jacobi_matrix = nil
        a_matrices = []
        
        begin
          delta = 0
          @iterations_count += 1
          previous_iteration_values = current_iteration_values.clone
          
          # посчитаем дельты значений из значений прошлой итерации
          deltas_equalations_matrix = []
          for i in 0...@equalations.size
            deltas_equalations_matrix[i] = []
            for j in 0...@equalations.size
              deltas_equalations_matrix[i] << @derivatives[i][j].call(previous_iteration_values)
            end
            deltas_equalations_matrix[i] << - @equalations[i].call(previous_iteration_values)
          end
          
          # we have delta equalations, solve them using linear equalation set class.
          value_deltas, delta_iterations = Requalations::Linear::Equalation.new(deltas_equalations_matrix).solve( :with => :seidel_method, :eps => 0.000000001 )
          value_deltas = value_deltas.to_a
          
          # recalculate X
          for i in 0...@equalations.size
            current_iteration_values[i] = previous_iteration_values[i] + value_deltas[i]
          end
          
          # get eps
          for i in 0...@equalations.size do 
            delta = [delta, (current_iteration_values[i] - previous_iteration_values[i]).abs].max
          end
          
        end while delta > options[:eps] && @iterations_count < options[:max_iterations]
        
        return [current_iteration_values, @iterations_count]
      end
    
    end
  end
end