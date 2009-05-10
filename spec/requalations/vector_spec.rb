require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vector do
  # Before each spec sentence
  before(:each) do
    # create a vector
    @vector = Vector.elements( [4,10,29,2,5,1] )
    @column_vector = Vector.elements( [ [1], [2], [29], [5], [10] ])
  end
  
  # It should have #max!
  it "should have #max method" do
    @vector.max.should == 29.0
  end
  
  it "should have #min method" do
    @vector.min.should == 1.0
  end
  
  it "should get max_index properly" do
    @vector.max_index.should == 2
  end
  
  it "should get min_index properly" do
    @vector.min_index.should == 5
  end
  
  it "should find max in column_vector" do
    @column_vector.max.should == 29
  end
  
  it "should get max_index in column_vector" do
    @column_vector.max_index.should == 2
  end
  
  it "should be able to slice vector" do
    @column_vector.slice(2..5).should == Vector.elements([ [29], [5], [10] ])
  end
end