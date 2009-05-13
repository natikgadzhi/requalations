require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

# 
# Метод прогонки 
# 
describe Requalations::Linear::Equalation do
  before(:each) do
    @equalation_data = [
      [-6, +6, 0, 0, 0, 30],
      [2, 10, -7, 0, 0, -31],
      [0, -8, 18, 9, 0, 108],
      [0, 0, 6, -17, -6, -114],
      [0, 0, 0, 9, 14, 124]
    ]
    @equalation = Requalations::Linear::Equalation.new(@equalation_data)
  end
  
  it "should solve!" do
    puts @equalation.solve(:with => :sweep).to_a.map{ |e| e.to_f.round() }
  end
end