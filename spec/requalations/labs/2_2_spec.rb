require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# Covers 2.1 task
describe Requalations::NonLinear::EqualationSet do
  
  
  it "should solve nonlinear equalation set using " do
    # Create an equalation
    @equalation_set = Requalations::NonLinear::EqualationSet.new([0.5, 0.5])
    @equalation_set.add do |variables|  
      Math.sqrt( 2 * Math.log10( variables[1] ) + 1 )
    end
    @equalation_set.add do |variables|
      ( variables[0] * variables[0] + 2 ) / ( 2 * variables[0] )
    end
    
    data, iterations = @equalation_set.solve
    
    puts "#{data[0]} and #{data[1]} in #{iterations} iterations"
    
  end

  
end