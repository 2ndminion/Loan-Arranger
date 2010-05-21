class AddLoanRiskAndTerm < ActiveRecord::Migration
    def self.up
      add_column :loans, :risk, :integer
      add_column :loans, :term, :integer
    end

    def self.down
      remove_column :loans, :risk
      remove_column :loans, :term
    end
end
