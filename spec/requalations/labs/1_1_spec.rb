require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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
  
  # Проверка самого класса уравнения.
  it "should solve the equalation" do
    @equalation = Requalations::Linear::Equalation.new(@equalation)
    puts @equalation.solve
  end
  
end


