require 'spec_helper.rb'

describe Plaid::Institution do
  describe "#all" do
    it "returns institutions" do
      expect(Plaid::Institution.all).to be_an(Array)
    end
  end

  describe "#find" do
    it "finds American Express" do
      expect(Plaid::Institution.find('5301a9d704977c52b60000db')[:name]).to eq('American Express')
    end
  end
end
