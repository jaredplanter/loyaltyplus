class ChangeCreditAndDebitDefaultOnPointLedgerEntries < ActiveRecord::Migration[5.0]
  def change
    change_column_default :point_ledger_entries, :credit, 0
    change_column_default :point_ledger_entries, :debit, 0
  end
end
