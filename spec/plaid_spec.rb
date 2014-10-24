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
    context 'no mfa' do
      it 'returns a response code of 200' do
        response = Plaid.call.add_account_auth('wells','plaid_test','plaid_good')
        expect(response[:code]).to eq(200)
      end
    end

    context 'pin and required mfa' do
      it 'returns a response code of 201' do
        response = Plaid.call.add_account_auth('usaa', 'plaid_test', 'plaid_good', '1234')
        expect(response[:code]).to eq(201)
      end
    end

    context 'mfa required' do
      it 'returns a response code of 201' do
        response = Plaid.call.add_account_auth('chase','plaid_test','plaid_good')
        expect(response[:code]).to eq(201)
      end
    end

    context 'wrong credentials' do
      it 'returns a response code of 402' do
        expect {
          Plaid.call.add_account_auth('wells','plaid_test','plaid_bad')
        }.to raise_error('402 Payment Required')
      end
    end
  end

  describe "Connect" do
    it 'returns a response code of 200' do
      response = Plaid.call.add_account_connect('amex','plaid_test','plaid_good')
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
