require 'spec_helper.rb'

describe Plaid::Entity do
  describe "#find" do
    it "finds " do
      expect(Plaid::Entity.find('526842af335228673f0000b7')[:name]).to eq('Starbucks')
    end
  end
end
