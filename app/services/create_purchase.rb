class CreatePurchase < Struct.new(:user, :amount)
  attr_accessor :purchase

  def call
    @purchase = user.purchases.create amount: amount
    purchase.point_ledger_entries.create credit: amount, balance: new_balance
    user.points_balance
  end

  private

  def new_balance
    previous_balance + amount
  end

  def previous_balance
    if latest_ledger_entry.present?
      latest_ledger_entry.balance
    else
      0
    end
  end

  def latest_ledger_entry
    purchase.point_ledger_entries.last || user.point_ledger_entries.last
  end
end
