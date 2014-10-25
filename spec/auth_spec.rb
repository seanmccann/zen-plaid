require 'spec_helper.rb'

describe Plaid::Auth do
  context 'unsupported institution' do
    it "returns 404 http code" do
      connection = Plaid::Auth.add({type: 'amex', username: 'plaid_test', password: 'plaid_good'})
      expect(connection[:code]).to eq(404)
    end
  end

  context 'missing password' do
    it "returns 400 http code" do
      connection = Plaid::Auth.add({type: 'bofa', username: 'plaid_test'})
      expect(connection[:code]).to eq(400)
    end
  end

  context 'pin when its not needed' do
    it "returns 200 http code" do
      connection = Plaid::Auth.add({type: 'schwab', username: 'plaid_test', password: 'plaid_good', pin: 1234})
      expect(connection[:code]).to eq(200)
    end
  end

  context 'forget pin when its needed' do
    it "returns 402 http code" do
      connection = Plaid::Auth.add({type: 'usaa', username: 'plaid_test', password: 'plaid_good'})
      expect(connection[:code]).to eq(402)
    end
  end

  context 'wrong credentials with no mfa' do
    it "returns 402 http code" do
      connection = Plaid::Auth.add({type: 'schwab', username: 'plaid_test', password: 'plaid_bad'})
      expect(connection[:code]).to eq(402)
    end

    it "returns error message" do
      connection = Plaid::Auth.add({type: 'schwab', username: 'plaid_test', password: 'plaid_bad'})
      expect(connection[:error][:message]).to eq('invalid credentials')
    end

    it "returns error resolution" do
      connection = Plaid::Auth.add({type: 'schwab', username: 'plaid_test', password: 'plaid_bad'})
      expect(connection[:error][:resolve]).to eq('The username or password provided were not correct.')
    end
  end

  context 'wrong credentials with mfa' do
    it "returns 402 http code" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_test', password: 'plaid_bad'})
      expect(connection[:code]).to eq(402)
    end

    it "returns error message" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_test', password: 'plaid_bad'})
      expect(connection[:error][:message]).to eq('invalid credentials')
    end

    it "returns error resolution" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_test', password: 'plaid_bad'})
      expect(connection[:error][:resolve]).to eq('The username or password provided were not correct.')
    end
  end

  context 'correct credentials with no mfa' do
    it "returns 200 http code" do
      connection = Plaid::Auth.add({type: 'schwab', username: 'plaid_test', password: 'plaid_good'})
      expect(connection[:code]).to eq(200)
    end

    it "returns accounts" do
      connection = Plaid::Auth.add({type: 'schwab', username: 'plaid_test', password: 'plaid_good'})
      expect(connection[:message]).to have_key(:accounts)
    end
  end

  # context 'correct credentials with pin' do
  #   it "returns 200 http code" do
  #     connection = Plaid::Auth.add({type: 'usaa', username: 'plaid_test', password: 'plaid_good', pin: 1234})
  #     puts connection.inspect
  #     expect(connection[:code]).to eq(200)
  #   end

  #   it "returns accounts" do
  #     connection = Plaid::Auth.add({type: 'usaa', username: 'plaid_test', password: 'plaid_good', pin: 1234})
  #     expect(connection[:message]).to have_key(:accounts)
  #   end

  #   it "returns transactions" do
  #     connection = Plaid::Auth.add({type: 'usaa', username: 'plaid_test', password: 'plaid_good', pin: 1234})
  #     expect(connection[:message]).to have_key(:transactions)
  #   end
  # end

  context 'correct credentials with default chase mfa' do
    it "returns 201 http code" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_test', password: 'plaid_good'})
      expect(connection[:code]).to eq(201)
    end

    it "returns access_token" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message]).to have_key(:access_token)
    end

    it "returns mfa type" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message][:type]).to eq("device")
    end

    it "returns mfa message" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message][:mfa][:message]).to eq("Code sent to t..t@plaid.com")
    end
  end

  context 'correct credentials with chase mfa choice' do
    it "returns 201 http code" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
      expect(connection[:code]).to eq(201)
    end

    it "returns access_token" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
      expect(connection[:message]).to have_key(:access_token)
    end

    it "returns mfa type as list" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
      expect(connection[:message][:type]).to eq("list")
    end

    it "returns mfa list array" do
      connection = Plaid::Auth.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
      expect(connection[:message][:mfa]).to be_an(Array)
    end
  end

  context 'correct credentials with citi bank' do
    it "returns 201 http code" do
      connection = Plaid::Auth.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:code]).to eq(201)
    end

    it "returns access_token" do
      connection = Plaid::Auth.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message]).to have_key(:access_token)
    end

    it "returns mfa type" do
      connection = Plaid::Auth.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message][:type]).to eq("selections")
    end

    it "returns mfa list array" do
      connection = Plaid::Auth.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message][:mfa]).to be_an(Array)
    end

    it "returns mfa questions" do
      connection = Plaid::Auth.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message][:mfa][0]).to have_key(:question)
    end

    it "returns mfa question selections" do
      connection = Plaid::Auth.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
      expect(connection[:message][:mfa][0]).to have_key(:answers)
    end
  end
end
