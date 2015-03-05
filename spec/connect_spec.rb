require 'spec_helper.rb'

describe Plaid::Connect do
  describe "#get" do
    it "returns 200 http code" do
      connection = Plaid::Connect.get({access_token: 'test', type: 'chase'})
      expect(connection[:code]).to eq(200)
    end

    it "returns transactions" do
      connection = Plaid::Connect.get({access_token: 'test', type: 'chase'})
      expect(connection[:message]).to have_key(:transactions)
    end

    it "returns accounts" do
      connection = Plaid::Connect.get({access_token: 'test', type: 'chase'})
      expect(connection[:message]).to have_key(:accounts)
    end
  end

  describe "#mfa_step" do
    context 'correct mfa reply code' do
      it "returns 200 http code" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'chase', mfa: '1234'})
        expect(connection[:code]).to eq(200)
      end
    end

    context 'wrong mfa reply code' do
      it "returns 402 http code" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'chase', mfa: '666'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'chase', mfa: '666'})
        expect(connection[:error][:message]).to eq("invalid mfa")
      end
    end

    context 'correct mfa reply answer' do
      it "returns 200 http code" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'us', mfa: 'tomato'})
        expect(connection[:code]).to eq(200)
      end
    end

    context 'wrong mfa reply answer' do
      it "returns 402 http code" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'us', mfa: 'wrong'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'us', mfa: 'wrong'})
        expect(connection[:error][:message]).to eq("invalid mfa")
      end
    end

    context 'correct mfa reply selections' do
      it "returns 200 http code" do
        connection = Plaid::Connect.mfa_step({access_token: 'test', type: 'citi', credentials: {pin: 1234}})
        expect(connection[:code]).to eq(200)
      end
    end
  end

  describe "#add" do
    context 'missing password' do
      it "returns 400 http code" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test'})
        expect(connection[:code]).to eq(400)
      end
    end

    context 'pin when its not needed' do
      it "returns 200 http code" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good', pin: 1234})
        expect(connection[:code]).to eq(200)
      end
    end

    context 'forget pin when its needed' do
      it "returns 402 http code" do
        connection = Plaid::Connect.add({type: 'usaa', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:code]).to eq(400)
      end
    end

    context 'locked credentials with no mfa' do
      it "returns 402 http code" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_locked'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_locked'})
        expect(connection[:error][:message]).to eq('account locked')
      end

      it "returns error resolution" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_locked'})
        expect(connection[:error][:resolve]).to include('The account is locked.')
      end
    end

    context 'wrong credentials with no mfa' do
      it "returns 402 http code" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_bad'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_bad'})
        expect(connection[:error][:message]).to eq('invalid credentials')
      end

      it "returns error resolution" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_bad'})
        expect(connection[:error][:resolve]).to eq('The username or password provided were not correct.')
      end
    end

    context 'wrong credentials with mfa' do
      it "returns 402 http code" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_test', password: 'plaid_bad'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_test', password: 'plaid_bad'})
        expect(connection[:error][:message]).to eq('invalid credentials')
      end

      it "returns error resolution" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_test', password: 'plaid_bad'})
        expect(connection[:error][:resolve]).to eq('The username or password provided were not correct.')
      end
    end

    context 'correct credentials with no mfa' do
      it "returns 200 http code" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:code]).to eq(200)
      end

      it "returns accounts" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:message]).to have_key(:accounts)
      end

      it "returns transactions" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:message]).to have_key(:transactions)
      end
    end

    context 'correct credentials with pin' do
      it "returns 200 http code" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good', pin: 1234})
        expect(connection[:code]).to eq(200)
      end

      it "returns accounts" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good', pin: 1234})
        expect(connection[:message]).to have_key(:accounts)
      end

      it "returns transactions" do
        connection = Plaid::Connect.add({type: 'amex', username: 'plaid_test', password: 'plaid_good', pin: 1234})
        expect(connection[:message]).to have_key(:transactions)
      end
    end

    context 'correct credentials with default chase mfa' do
      it "returns 201 http code" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:code]).to eq(201)
      end

      it "returns access_token" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message]).to have_key(:access_token)
      end

      it "returns mfa type" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message][:type]).to eq("device")
      end

      it "returns mfa message" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message][:mfa][:message]).to eq("Code sent to t..t@plaid.com")
      end
    end

    context 'correct credentials with chase mfa choice' do
      it "returns 201 http code" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
        expect(connection[:code]).to eq(201)
      end

      it "returns access_token" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
        expect(connection[:message]).to have_key(:access_token)
      end

      it "returns mfa type as list" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
        expect(connection[:message][:type]).to eq("list")
      end

      it "returns mfa list array" do
        connection = Plaid::Connect.add({type: 'chase', username: 'plaid_selections', password: 'plaid_good', options: {list: true}})
        expect(connection[:message][:mfa]).to be_an(Array)
      end
    end

    context 'correct credentials with citi bank' do
      it "returns 201 http code" do
        connection = Plaid::Connect.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:code]).to eq(201)
      end

      it "returns access_token" do
        connection = Plaid::Connect.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message]).to have_key(:access_token)
      end

      it "returns mfa type" do
        connection = Plaid::Connect.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message][:type]).to eq("selections")
      end

      it "returns mfa list array" do
        connection = Plaid::Connect.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message][:mfa]).to be_an(Array)
      end

      it "returns mfa questions" do
        connection = Plaid::Connect.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message][:mfa][0]).to have_key(:question)
      end

      it "returns mfa question selections" do
        connection = Plaid::Connect.add({type: 'citi', username: 'plaid_selections', password: 'plaid_good'})
        expect(connection[:message][:mfa][0]).to have_key(:answers)
      end
    end
  end

  describe "#update_user" do
    context 'missing access_token' do
      it "returns 400 http code" do
        connection = Plaid::Connect.update_user({type: 'amex', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:code]).to eq(400)
      end
    end

    context 'missing password' do
      it "returns 400 http code" do
        connection = Plaid::Connect.update_user({access_token: 'test', type: 'amex', username: 'plaid_test'})
        expect(connection[:code]).to eq(402)
      end
    end

    context 'pin when its not needed' do
      it "returns 200 http code" do
        connection = Plaid::Connect.update_user({access_token: 'test', type: 'amex', username: 'plaid_test', password: 'plaid_good', pin: 1234})
        expect(connection[:code]).to eq(200)
      end
    end

    context 'forget pin when its needed' do
      it "returns 402 http code" do
        connection = Plaid::Connect.update_user({access_token: 'test', type: 'usaa', username: 'plaid_test', password: 'plaid_good'})
        expect(connection[:code]).to eq(402)
      end
    end

    context 'locked credentials with no mfa' do
      it "returns 402 http code" do
        connection = Plaid::Connect.update_user({access_token: 'test', type: 'amex', username: 'plaid_test', password: 'plaid_locked'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.update_user({access_token: 'test', type: 'amex', username: 'plaid_test', password: 'plaid_locked'})
        expect(connection[:error][:message]).to eq('account locked')
      end

      it "returns error resolution" do
        connection = Plaid::Connect.update_user({access_token: 'test', type: 'amex', username: 'plaid_test', password: 'plaid_locked'})
        expect(connection[:error][:resolve]).to include('The account is locked.')
      end
    end
  end

  describe "#update_mfa_step" do
    context 'correct mfa reply code' do
      it "returns 200 http code" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'chase', mfa: '1234'})
        expect(connection[:code]).to eq(200)
      end
    end

    context 'wrong mfa reply code' do
      it "returns 402 http code" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'chase', mfa: '666'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'chase', mfa: '666'})
        expect(connection[:error][:message]).to eq("invalid mfa")
      end
    end

    context 'correct mfa reply answer' do
      it "returns 200 http code" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'us', mfa: 'tomato'})
        expect(connection[:code]).to eq(200)
      end
    end

    context 'wrong mfa reply answer' do
      it "returns 402 http code" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'us', mfa: 'wrong'})
        expect(connection[:code]).to eq(402)
      end

      it "returns error message" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'us', mfa: 'wrong'})
        expect(connection[:error][:message]).to eq("invalid mfa")
      end
    end

    context 'correct mfa reply selections' do
      it "returns 200 http code" do
        connection = Plaid::Connect.update_mfa_step({access_token: 'test', type: 'citi', credentials: {pin: 1234}})
        expect(connection[:code]).to eq(200)
      end
    end
  end
end
