class ChangeAmountDefaultOnPurchase < ActiveRecord::Migration[5.0]
  def change
    change_column_default :purchases, :amount, 0
  end
end
