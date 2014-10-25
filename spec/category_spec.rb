require 'spec_helper.rb'

describe Plaid::Category do
  describe "#all" do
    it "returns categories" do
      expect(Plaid::Category.all).to be_an(Array)
    end
  end

  describe "#find" do
    it "finds American Express" do
      expect(Plaid::Category.find('52544965f71e87d007000049')[:hierarchy].first).to eq('Food and Drink')
    end
  end
end
