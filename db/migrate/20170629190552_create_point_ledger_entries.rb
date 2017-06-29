class CreatePointLedgerEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :point_ledger_entries do |t|
      t.integer :purchase_id
      t.integer :credit
      t.integer :debit
      t.integer :balance

      t.timestamps
    end
  end
end
