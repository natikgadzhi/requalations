require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Covers 1.3
describe "Iterational Methods" do
  before(:each) do
    @equalation_data = [
      [ 10, -1, -2, 5, -99],
      [ 4, 28, 7, 9, 0],
      [ 6, 5, -23, 4, 67],
      [ 1, 4, 5, -15, 58]
    ]
  end
  
  it "Can solve using simple iterations" do
    @equalation = Requalations::Linear::Equalation.new( @equalation_data)
    vector, iterations_count = @equalation.solve({ :with => :simple_iterations, :eps => 0.000000000000001 })
    puts vector.to_a.map { |e| e.round }
    
    puts "in #{iterations_count} iterations."
    
    # Vector[-8, 4, -5, -5]
  end
  
  it "Can solve using seidel method" do
    @equalation = Requalations::Linear::Equalation.new( @equalation_data)
    vector, iterations_count = @equalation.solve({ :with => :seidel_method, :eps => 0.00001 })
    puts vector.to_a.map { |e| e.round }
    
    puts "in #{iterations_count} iterations."
  end
  
end