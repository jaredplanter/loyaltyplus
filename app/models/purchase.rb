class Purchase < ApplicationRecord
  belongs_to :user
  has_many :point_ledger_entries, dependent: :destroy

  def points_remaining
    if point_ledger[:debits] > point_ledger[:credits]
      0
    else
      point_ledger[:credits] - point_ledger[:debits]
    end
  end

  private

  def point_ledger
    credits_and_debits = {credits:0, debits:0}
    point_ledger_entries.each do |ledger_entry|
      credits_and_debits[:credits] += ledger_entry.credit
      credits_and_debits[:debits] += ledger_entry.debit
    end
    credits_and_debits
  end
end
