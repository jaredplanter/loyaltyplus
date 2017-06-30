require 'rails_helper'

RSpec.describe CreatePurchase, type: :service do
  let(:user) { User.create }
  subject(:create_purchase) { CreatePurchase.new(user, 1).call }

  describe '#call' do
    it 'creates a new purchase with the correct amount' do
      create_purchase
      purchase = user.purchases.first
      expect(purchase.amount).to eq 1
    end

    it 'creates a new point ledger entry with the correct amount' do
      create_purchase
      point_ledger_entry = user.point_ledger_entries.first
      expect(point_ledger_entry.credit).to eq 1
    end

    it 'returns the new point ledger balance' do
      expect(create_purchase).to eq 1
    end
  end
end
