require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# Generally covers matrices LU decomposition algorythm. \
# Also covers matrices #inverse_using_lu method
# Also covers matrices #determinant_using_lu method
# 
describe Matrix do
  
  before(:each) do
    # 
    @left_side_matrix = Matrix.rows([
      [ 7, 8, 4, -6],
      [ -1, 6, -2, -6],
      [ 2, 9, 6, -4],
      [ 5, 9, 1, 1]
    ])
  end
  
  #
  # Покрывает задание 1.1 
  # 
  describe "LU decomposition" do
    
    # We should have working lu method, which would return the staff ß
    it "should get lu decomposition" do
      # проверяем разложение
      l, u, p = @left_side_matrix.lu_decompose
      a = p * @left_side_matrix
      b = l * u
      # удостовериться, что разложение верно
      a.should == b
      
      # удостовериться, что вектор перестановок правильный
      # puts p
      # puts @left_side_matrix.permutation_vector
    end
    
    it "should get matrix determinant using lu decomposition" do
      @left_side_matrix.determinant_using_lu_decomposition.should == @left_side_matrix.determinant
    end
    
    it "should be able to get inverse matrix" do
      inverse = @left_side_matrix.inverse_using_lu_decomposition
      (@left_side_matrix * inverse).should == Matrix::identity(@left_side_matrix.column_size)
    end
    
  end
end