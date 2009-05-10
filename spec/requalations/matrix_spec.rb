require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Matrix do
  before(:each) do
    @matrix = Matrix.rows([
      [1,2,3],
      [4,5,6],
      [7,8,9]
    ])
    
    @equalation_matrix = Matrix.rows([
      [ 7, 8, 4, -6, -126 ],
      [ -1, 6, -2, -6, -42 ],
      [ 2, 9, 6, -4, -115 ],
      [ 5, 9, 1, 1, -67 ]
    ])
    
    @left_side_matrix = Matrix.rows([
      [ 7, 8, 4, -6],
      [ -1, 6, -2, -6],
      [ 2, 9, 6, -4],
      [ 5, 9, 1, 1]
    ])
  end
  
  it "should be able to swap rows" do
    @matrix.swap_rows!(1,2)
    @matrix.row(1).should == Vector.elements([7,8,9])
    @matrix.row(2).should == Vector.elements([4,5,6]) 
  end
  
  it "should get lu decomposition" do
    l, u, p = @left_side_matrix.lu
    a = l*u*p
    
    a.determinant.should == @left_side_matrix.determinant
    a.should == @left_side_matrix
  end
  
end