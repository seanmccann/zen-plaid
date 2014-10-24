require 'spec_helper.rb'
describe Plaid, 'Call' do
  before(:all) do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.client_id = keys['client_id']
      p.secret = keys['secret']
    end
  end

  describe "Auth" do
    it 'returns a response code of 200' do
      response = Plaid.call.add_account_auth('wells','plaid_test','plaid_good','test@plaid.com')
      expect(response[:code]).to eq(200)
    end

    it 'returns a response code of 201' do
      Plaid.call.add_account_auth('chase','plaid_test','plaid_good','test@plaid.com')
    end
  end

  describe "Connect" do
    it 'returns a response code of 200' do
      response = Plaid.call.add_account_connect('amex','plaid_test','plaid_good','test@plaid.com')
      expect(response[:code]).to eq(200)
    end
  end

  describe "Places" do
    it 'calls get_place and returns a response code of 200' do
      place = Plaid.call.get_place('526842af335228673f0000b7')
      expect(place[:code]).to eq(200)
    end
  end

  describe "Institutions" do
    it 'calls get_institutions and returns a response code of 200' do
      place = Plaid.call.get_institutions
      expect(place[:code]).to eq(200)
    end

    it 'gets amex institution information' do
      institution = Plaid.call.get_institution('5301a9d704977c52b60000db')
      expect(institution[:message]['name']).to eq("American Express")
      expect(institution[:message]['mfa']).to be_empty
      expect(institution[:code]).to eq(200)
    end
  end
end

describe Plaid, 'Customer' do
  before :all do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.client_id = keys['client_id']
      p.secret = keys['secret']
    end
  end

  it 'calls get_transactions and returns a response code of 200' do
    transactions = Plaid.customer.get_transactions('test')
    expect(transactions[:code]).to eq(200)
  end

  it 'calls mfa_auth_step and returns a response code of 200' do
    new_account = Plaid.customer.mfa_auth_step('test','1234','chase', send_method: {type: :phone})
    expect(new_account[:code]).to eq(200)
  end

  it 'calls mfa_connect_step and returns a response code of 200' do
    new_account = Plaid.customer.mfa_connect_step('test', '1234', 'chase', send_method: {type: :phone})
    expect(new_account[:code]).to eq(200)
  end

  it 'calls delete_account and returns a response code of 200' do
    message = Plaid.customer.delete_account('test')
    expect(message[:code]).to eq(200)
  end
end
