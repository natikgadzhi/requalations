require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vector do
  # Before each spec sentence
  before(:each) do
    # create a vector
    @vector = Vector.elements( [4,10,29,2,5,1] )
  end
  
  # It should have #max!
  it "should have #max method" do
    @vector.max.should == 29.0
  end
  
  it "should have #min method" do
    @vector.min.should == 1.0
  end
end