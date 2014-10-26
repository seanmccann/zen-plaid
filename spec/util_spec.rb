require 'spec_helper.rb'

describe Plaid::Util do
  describe ".credentials_params" do
    context 'already has credentials' do
      let(:params) { { credentials: {username: 'plaid_test', password: 'plaid_good'}, type: 'chase' } }
      let(:fixed_params) { Plaid::Util.credentials_params(params) }

      it { expect(fixed_params).to have_key(:credentials) }
      it { expect(fixed_params[:credentials]).to have_key(:username) }
      it { expect(fixed_params[:credentials]).to have_key(:password) }
      it { expect(fixed_params[:credentials]).to_not have_key(:pin) }
    end

    context 'no credentials' do
      let(:params) { { username: 'plaid_test', password: 'plaid_good', type: 'chase' } }
      let(:fixed_params) { Plaid::Util.credentials_params(params) }

      it { expect(fixed_params).to have_key(:credentials) }
      it { expect(fixed_params[:credentials]).to have_key(:username) }
      it { expect(fixed_params[:credentials]).to have_key(:password) }

      it { expect(fixed_params).to_not have_key(:username) }
      it { expect(fixed_params).to_not have_key(:password) }
      it { expect(fixed_params[:credentials]).to_not have_key(:pin) }
    end

    context 'no credentials with pin' do
      let(:params) { { username: 'plaid_test', password: 'plaid_good', pin: 1234, type: 'chase' } }
      let(:fixed_params) { Plaid::Util.credentials_params(params) }

      it { expect(fixed_params).to have_key(:credentials) }
      it { expect(fixed_params[:credentials]).to have_key(:username) }
      it { expect(fixed_params[:credentials]).to have_key(:password) }
      it { expect(fixed_params[:credentials]).to have_key(:pin) }

      it { expect(fixed_params).to_not have_key(:username) }
      it { expect(fixed_params).to_not have_key(:password) }
      it { expect(fixed_params).to_not have_key(:pin) }
    end
  end
end
