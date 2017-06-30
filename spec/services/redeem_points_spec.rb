require 'rails_helper'

RSpec.describe RedeemPoints, type: :service do
  let(:user) { User.create }
  let(:debit_amount) { 0 }
  let(:credit_100_points_to_ledger) { CreatePurchase.new(user, 100).call }
  subject(:redeem_points) { RedeemPoints.new(user, debit_amount).call }

  describe '#call' do
    context 'the user has less than 100 points' do
      it 'returns the point balance error' do
        point_balance_error = "User must have at least 100 points to start redeeming."
        expect(redeem_points).to eq point_balance_error
      end
    end

    context 'the debit amount exceeds the point balance' do
      let(:debit_amount) { 101 }

      it 'returns the debit amount error' do
        credit_100_points_to_ledger
        debit_amount_error = "The debit amount exceeds the user's point balance."
        expect(redeem_points).to eq debit_amount_error
      end
    end

    context 'when there are no errors' do
      let(:debit_amount) { 1 }

      it 'debits the point ledger for 1 point' do
        credit_100_points_to_ledger
        expect(redeem_points).to eq 99
      end
    end

    context 'when the debit amount is 0' do
      it 'does nothing and returns the balance' do
        credit_100_points_to_ledger
        expect(redeem_points).to eq 100
      end
    end
  end
end
