module Requalations
  module NonLinear
    
    ## Single nonlinear equalation
    # Solves equalation like X + X^2 - tg(x) + ... = 0
    # 
    class Equalation
      
      ## Settings 
      # Default init options like minimal and maximal argument value etc
      DEFAULT_INITIALIZE_OPTIONS = { :target_value => 0 }.freeze
      # Default solve options like which method use to solve 
      DEFAULT_SOLVE_OPTIONS = { :method => :newton, :default_argument_value => 0, :eps => 0.0001, :max_iterations => 2000}.freeze
      
      ## Properties
      # Give public access to equalation's proc
      # 
      attr_reader :function
      
      ## Initialize
      # Initialize our equalation here
      # options - hash of options. 
      #  :x_min => minimal argument value
      #  :x_max => maximal argument value
      # 
      # &function - function to solve
      # 
      def initialize( options = {}, &func)
        ## Save the parameters 
        @function = func
        
        # Merge options with defaults and throw on any errors
        options = DEFAULT_INITIALIZE_OPTIONS.merge(options)
        raise StandardError.new("You should provide X restrictions") unless options.has_key?(:minimal_x) && options.has_key?(:maximal_x)
        
        # Copy argument settings
        @minimal_argument = options[:minimal_x]
        @maximal_argument = options[:maximal_x]
        @target_value = options[:target_value]
      end
      
      ## Instance methods
      # Solve the equalation with the folowing options
      # 
      def solve( options = {})
        options = DEFAULT_SOLVE_OPTIONS.merge(options)
        
        send "solve_using_#{options[:method]}", options
      end
      
      ## Solve the equalation using newton's method
      # 
      def solve_using_newton( options = {})
        current_x = options[:default_argument_value]
        previous_x = options[:previous_x]
        next_x = 0
        iterations_count = 0
        
        begin
          iterations_count += 1
          # move values
          previous_x = current_x
          current_x = next_x
          
          # find new value
          next_x = current_x - ( (@function.call(current_x)*(current_x - previous_x)) / (@function.call(current_x) - @function.call(previous_x) ) )
          
        end while (next_x - current_x).abs > options[:eps] && iterations_count < options[:max_iterations]
        
        if iterations_count != options[:max_iterations]
          return [next_x, iterations_count]
        else
          raise StandardError.new("Maximum iterations count reached, current solution: #{next_x}")
        end
        
      end
      
      ## Solve the equalation using iterations method
      # method accepts x = ** block and options hash. 
      # value - the prev. iteration value
      # new_value = current argument value
      # block = the function to use for argument search
      # 
      def self.solve_using_iterations( options = {}, &function )
        # prepare options!
        options = DEFAULT_SOLVE_OPTIONS.merge(options)
        
        # Retrieve default value from options and reset iterations counter
        value = new_value = options[:default_argument_value]
        iterations_count = 0
        
        # Start iterations
        begin
          iterations_count += 1
          value = new_value
          new_value = function.call(value)
        end while (new_value - value).abs > options[:eps] && iterations_count < options[:max_iterations]
        
        if iterations_count != options[:max_iterations]
          return [new_value, iterations_count]
        else
          raise StandardError.new("Maximum iterations count reached, current solution: #{new_value}")
        end
      end
    end
  end
end