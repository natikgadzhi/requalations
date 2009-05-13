require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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
      [ 6.0, 5.0, -6.0],
      [ 4.0, -6.0, 9.0],
      [ 6.0, -6.0, 1.0]
    ])
  end
  
  # First step - check, if the matrix class has the method
  it "has #qr_decompose method" do
    Matrix.public_instance_methods.should include("qr_decompose")
  end
  
  # Specify QR
  # 
  it "should provide a valid QR decomposition" do
    # at least, we ensure that it raises no error and does something
    q, r, i = @matrix.qr_decompose
    
    same_matrix = q * r
    same_matrix.to_a.map{ |row| row.map{ |element| element.round } }.should == @matrix.to_a
  end
  
  # Eigenvalues
  # 
  it "should provide eigenvalues based on QR decomposition" do
    puts @matrix.eigenvalues_using_qr_decomposition(0.1)
  end
  
end