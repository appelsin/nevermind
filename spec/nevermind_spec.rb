describe Nevermind do
  xit "broccoli is gross" do
    Foodie::Food.portray("Broccoli").should eql("Gross!")
  end

  xit "anything else is delicious" do
    Foodie::Food.portray("Not Broccoli").should eql("Delicious!")
  end
end