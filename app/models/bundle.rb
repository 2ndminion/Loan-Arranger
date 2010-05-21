class Bundle < ActiveRecord::Base
  
  has_many :loans
  attr_accessor :risk

  def risk
    35
  end

end
