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
    
    @eigen_matrix = Matrix.rows([
      [ -7, -9, 1],
      [ -9, 7, 2],
      [ 1, 2, 9] 
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
  
  # it "should be able to get inverse matrix" do
  #   inverse = @left_side_matrix.inverse_using_lup
  #   
  #   puts @left_side_matrix.inverse
  #   puts "<br>"
  #   puts inverse
  #   # (@left_side_matrix * inverse).should == Matrix::identity(@left_side_matrix.column_size)
  # end
  
  it "should find eigenvectors" do
    values, vectors, iterations =  @eigen_matrix.eigenvalues_using_rotations( 0.3 )
    
    puts values.to_a.map {|e| e.round }
    puts "<br>"
    puts "eigen vectors: #{vectors.map { |e| e.to_a.map{ |v| v.round }; "#{e}<br>"}}<br>"
    
    puts " in #{iterations} rotations"
  end
  
  
  
end