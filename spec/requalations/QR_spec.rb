require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# 1.5 of Moscow University of Aviation 08-306@2009 labs
# Provide a methods to get QR matrix decomposition and
# based on that, provide eigenvalues of the matrix given with given epsipon.
# 
# (c) 2009 Nat Gadgibalaev <iam@railsmaniac.com>
# Additional information on licencing and getting help with this - ./LICENSE file. 
# 
describe ::Matrix do
  
  # This code is being executed before each "it" statement does.
  before(:each) do
    # The matrix to work with
    @matrix = Matrix.rows( [
      [ 6, 5, -6],
      [ 4, -6, 9],
      [ 6, -6, 1]
    ])
  end
  
  # First step - check, if the matrix class has the method
  it "has #qr method" do
    Matrix.public_instance_methods.should include("qr")
  end
  
  # Specify QR
  # 
  it "should provide a valid QR decomposition" do
    # at least, we ensure that it raises no error and does something
    q, r, i = @matrix.qr
    puts "Q: #{q}<br>R: #{r}<br> in #{i} iterations."
  end
  
  # Eigenvalues
  # 
  it "should provide eigenvalues based on QR decomposition" do
    puts @matrix.eigenvalues_using_qr(0.1)
  end
  
end