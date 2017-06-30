require 'rails_helper'

RSpec.describe User, type: :model do
  let(:point_ledger_entries) { [double(balance: 1)] }
  subject(:user) { User.new }

  describe '#points_balance' do
    context 'when the point ledger is empty' do
      it 'it returns 0' do
        allow(user).to receive(:point_ledger_entries).and_return []
        expect(user.points_balance).to eq 0
      end
    end
    context 'when the point ledger is not empty' do
      it 'returns the current balance' do
        allow(user).to receive(:point_ledger_entries).and_return point_ledger_entries
        expect(user.points_balance).to eq 1
      end
    end
  end
end
