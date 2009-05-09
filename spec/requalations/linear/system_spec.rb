require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# Describes my system solving my linear equalation
# 
describe Requalations::Linear::System do
  # Before each it statement:
  before(:each) do
    # Store my coeficients and results array as rows
    @rows = [
      [ 7, 8, 4, -6, -126 ],
      [ -1, 6, -2, -6, -42 ],
      [ 2, 9, 6, -4, -115 ],
      [ 5, 9, 1, 1, -67 ] 
    ]
      
    # And create the equalation to solve
    @equalation = ::Requalations::Linear::System.from_matrix( @rows )
  end

  it "should be able to solve equalations systems" do
    @equalation.solve.to_a.flatten.should == [ -4.0, -5.0, -7.0, 5.0]
  end
  
  it "should be able to get source matrix determinant" do
    @equalation.equalation_coeficients.determinant.should == Float(2866.0)
    @equalation.det.should == Float(2866.0)
  end
  
  it "should be able to apply LU" do
    @eaulation.solve_using_lu
  end

end