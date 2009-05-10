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
    
    @another_task_left = Matrix.rows([
      [-2, -9, -3, 7],
      [-7, 8, 2, 5],
      [-6, 2, 0, 0],
      [0, -3, 8, -3]
    ])
  end
  
  it "should be able to swap rows" do
    @matrix.swap_rows!(1,2)
    @matrix.row(1).should == Vector.elements([7,8,9])
    @matrix.row(2).should == Vector.elements([4,5,6]) 
    
    @matrix.swap_rows!(0,2)
    @matrix.row(0).should == Vector.elements([4,5,6])
    @matrix.row(2).should == Vector.elements([1,2,3])    
  end
  
  it "should get lu decomposition" do
    l, u, p = @left_side_matrix.lu
    
    a = p * @left_side_matrix
    b = l * u

    a.should == b
  end
  
  it "ahother task to LU" do
    l,u,p = @another_task_left.lu
    a = p * @another_task_left
    b = l*u
    a.should == b
  end
  
end