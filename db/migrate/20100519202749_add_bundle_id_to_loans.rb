class AddBundleIdToLoans < ActiveRecord::Migration
  def self.up
    add_column :loans, :bundle_id, :integer
  end

  def self.down
    remove_column :loans, :bundle_id
  end
end
