require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Requalations::Linear::Equalation do
  before(:each) do
    @eigen_matrix = Matrix.rows([
      [ -7, -9, 1],
      [ -9, 7, 2],
      [ 1, 2, 9] 
    ])
  end

  it "should find eigenvectors" do
    values, vectors, iterations =  @eigen_matrix.eigenvalues_using_rotations( 0.3 )

    puts values.to_a.map {|e| e.round }
    puts "<br>"
    puts "eigen vectors: #{vectors.map { |e| e.to_a.map{ |v| v.round }; "#{e}<br>"}}<br>"

    puts " in #{iterations} rotations"
  end

end