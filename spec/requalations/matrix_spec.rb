require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Matrix do
  before(:each) do
    @matrix = Matrix.rows([
      [1,2,3],
      [4,5,6],
      [7,8,9]
    ])
  end
  
  it "should be able to swap rows" do
    @matrix.swap_rows!(1,2)
    @matrix.row(1).should == Vector.elements([7,8,9])
    @matrix.row(2).should == Vector.elements([4,5,6]) 
  end
end