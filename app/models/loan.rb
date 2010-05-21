class Loan < ActiveRecord::Base

  belongs_to :lender
  belongs_to :bundle
  
  cattr_reader :per_page
  @@per_page = 20
  
end
