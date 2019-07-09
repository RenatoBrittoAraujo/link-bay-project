require 'test_helper'

class PostTest < ActiveSupport::TestCase

  test "should generate post" do
    post = Post.new
    post.title = "oi como você esta"
    post.body = "tudo bem"
    post.category = Category.new
		post.author = users(:one)
		assert post.save
  end

  test "should not generate post without title" do
    post = Post.new
		post.category = Category.new
		post.author = users(:one)
    assert_not post.save
  end

  test "should not generate post without category" do
    post = Post.new
		post.title = 'hey how are you'
		post.author = users(:one)
    assert_not post.save
	end

	test "should not generate post with small title" do
    post = Post.new
    post.title = 'hey'
    assert_not post.save
	end
	
	test "should not generate post without author" do
    post = Post.new
		post.title = 'hey how are you'
		post.author = users(:one)
    assert_not post.save
  end
end
