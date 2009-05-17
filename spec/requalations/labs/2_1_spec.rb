require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# Covers 2.1 task
describe Requalations::NonLinear::Equalation do

  # итерации
  it "solves non-linear equalation using iterative_method" do
    solution, iterations = Requalations::NonLinear::Equalation.solve_using_iterations( :default_argument_value => 0.3, :eps => 0.00000000001 ) { |x| Math.sqrt((Math.tan(x) + 1)/5) }
    
    puts "#{solution} in #{iterations} iterations"
  end
  
  
  # ньютон
  it "should solve non-linear equalations using newton-method" do
    equalation = Requalations::NonLinear::Equalation.new( :minimal_x => 0, :maximal_x => 1) { |x| Math.tan(x) - 5 * ( x ** 2 ) + 1 }
    
    solution, iterations = equalation.solve( :method => :newton, :default_argument_value => 0.3, :previous_x => 0.2 )
    puts "#{solution} in #{iterations} iterations"
  end
  
end