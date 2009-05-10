require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Requalations::Linear::Equalation do
  
  before(:each) do
    # Матрица, для работы с декомпозицией. 
    @equalation_left = Matrix.rows([
      [ 7, 8, 4, -6],
      [ -1, 6, -2, -6],
      [ 2, 9, 6, -4],
      [ 5, 9, 1, 1]
    ])
    
    # Это наше уравнение, в таком формате мы передадим его в конструктор уравнений. 
    @equalation = [
      [ 7, 8, 4, -6, -126 ],
      [ -1, 6, -2, -6, -42 ],
      [ 2, 9, 6, -4, -115 ],
      [ 5, 9, 1, 1, -67 ]
    ]
    
    @equalaion_right = Vector.elements( [ [-126], [-42], [-115], [-67]])
  end
  
  
  # Проверяем разложение
  it "should perform LUP" do
    # получим матрицы разложения 
    l,u,p = @equalation_left.lu
    
    a = p * @equalation_left
    b = l * u
    # Проверяем, выполняется ли условие разложения
    a.should == b
  end
  
  
  # Проверяем детерминант
  it "should get matrix determinant from LUP" do
    l,u,p = @equalation_left.lu
    @equalation_left.determinant.should == (l*u*p).determinant 
  end
  
  # # Проверяем обратную матрицу
  # it "should get inverted matrix from LUP" do
  #    l,u,p = @equalation_left.lu
  #    
  # end
  
  # Проверка самого класса уравнения.
  it "should solve the equalation" do
    @equalation = Requalations::Linear::Equalation.new(@equalation)
    puts @equalation.solve
  end
  
end


