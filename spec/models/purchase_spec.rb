require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:larger_debits) { [double(credit: 0, debit: 300), double(credit: 100, debit: 0)] }
  let(:smaller_debits) { [double(credit: 0, debit: 100), double(credit: 300, debit: 0)] }
  subject(:purchase) { Purchase.new }

  describe '#points_remaining' do
    context 'when the debits are greater than the credits' do
      it 'returns 0' do
        allow(purchase).to receive(:point_ledger_entries).and_return larger_debits
        expect(purchase.points_remaining).to eq 0
      end
    end
    context 'when the debits are smaller than the credits' do
      it 'subtracts the credits from the debits' do
        allow(purchase).to receive(:point_ledger_entries).and_return smaller_debits
        expect(purchase.points_remaining).to eq 200
      end
    end
  end
end
