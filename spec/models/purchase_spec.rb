require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:point_ledger_entries) { [double(credit: 0, debit: 100), double(credit: 300, debit: 0)] }
  subject(:purchase) { Purchase.new }

  describe '#points_remaining' do
    it 'subtracts the credits from the debits' do
      allow(purchase).to receive(:point_ledger_entries).and_return point_ledger_entries
      expect(purchase.points_remaining).to eq 200
    end
  end

  describe '#points_earned' do
    it 'displays the amount since the points earned is 1:1' do
      expect(purchase.points_earned).to eq purchase.amount
    end
  end
end
