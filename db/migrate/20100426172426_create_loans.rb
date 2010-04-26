class CreateLoans < ActiveRecord::Migration
  def self.up
    create_table :loans do |t|
      t.integer :lender_id
      t.integer :borrower_id
      t.string :status
      t.string :type
      t.decimal :amount
      t.decimal :interest_rate
      t.timestamp :settlement_date
      t.boolean :locked

      t.timestamps
    end
  end

  def self.down
    drop_table :loans
  end
end
