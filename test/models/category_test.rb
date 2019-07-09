require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should not save a nameless category" do
    category = Category.new
    assert_not category.save
  end
end
