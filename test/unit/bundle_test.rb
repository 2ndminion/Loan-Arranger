require 'test_helper'

class BundleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_risk_calculation
    bundle = Bundle.find(id=1)
    assert bundle.id == 1 
    assert true
  end
end
