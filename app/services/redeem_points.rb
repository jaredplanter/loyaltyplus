class RedeemPoints
  attr_reader :user, :amount, :purchases

  def initialize user, amount
    @user = user
    @amount = amount
    @purchases = user.purchases
  end

  def call
    return point_balance_error if user_has_less_than_100_points?
    return debit_amount_error if debit_amount_exceeds_balance?
    debit_point_ledgers until amount.zero?
    user.points_balance
  end

  private

  def user_has_less_than_100_points?
    user.points_balance < 100
  end

  def debit_amount_exceeds_balance?
    amount > user.points_balance
  end

  def point_balance_error
    "User must have at least 100 points to start redeeming."
  end

  def debit_amount_error
    "The debit amount exceeds the user's point balance."
  end

  def debit_point_ledgers
    purchases.each do |purchase|
      points_remaining = purchase.points_remaining
      full_or_partial_debit points_remaining: points_remaining, purchase: purchase
    end
  end

  def full_or_partial_debit points_remaining:, purchase:
    if points_remaining > amount
      debit_point_ledger purchase: purchase, debit_amount: amount
    else
      debit_point_ledger purchase: purchase, debit_amount: points_remaining
    end
  end

  def debit_point_ledger purchase:, debit_amount:
    new_balance = user.points_balance - debit_amount
    purchase.point_ledger_entries.create debit: amount, balance: new_balance
    @amount -= debit_amount
  end
end
