require 'spec_helper.rb'

describe Plaid::Balance do
  describe "#get" do
    it "returns 200 http code" do
      expect(Plaid::Balance.get('test')[:code]).to eq(200)
    end

    it "returns accounts" do
      expect(Plaid::Balance.get('test')[:message][:accounts]).to be_an(Array)
    end

    it "returns accounts with balances" do
      expect(Plaid::Balance.get('test')[:message][:accounts][0]).to have_key(:balance)
    end
  end
end
