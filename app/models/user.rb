class User < ApplicationRecord
  has_many :purchases, dependent: :destroy
  has_many :point_ledger_entries, through: :purchases

  def points_balance
    @points_balance = if last_point_ledger_entry.present?
                        last_point_ledger_entry.balance
                      else
                        0
                      end
  end

  private

  def last_point_ledger_entry
    point_ledger_entries.last
  end
end
