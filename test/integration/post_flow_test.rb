require 'test_helper'
require_relative '../helpers/integration_helpers'

class PostFlowTest < ActionDispatch::IntegrationTest

	def setup
		@user = login_user :one
	end

	
	test "should create post" do
		get '/posts/new'
		assert_response :success
		post = make_random_post
		assert_redirected_to '/posts/' + Post.last.id.to_s
		follow_redirect!
	end

	test "should not create post because not logged in" do
		logout
		get '/posts/new'
		assert_response :redirect
		make_random_post
		assert_redirected_to '/'
	end

	test "should create post and delete" do
		post = make_random_post
		delete '/posts/' + Post.last.id.to_s
		assert_response :redirect
		assert_not_same post.title, Post.last.title
	end

	test "should create post and update" do
		make_random_post
		patch '/posts/' + Post.last.id.to_s,
			params: { post: { title: "batata", body: "2", category_id: categories(:two).id, author_id: users(:one).id } }
		assert_response :redirect
		post = Post.last
		assert_equal 'batata', post.title
		assert_equal '2', post.body
		assert_equal categories(:two).name, post.category.name
	end

	test "should upvote" do
		make_random_post
		upvote_last_post
		assert_equal 1, Post.last.vote_counter
	end

	test "should downvote" do
		make_random_post
		downvote_last_post
		assert_equal -1, Post.last.vote_counter
	end

	test "should not upvote because not logged in" do
		make_random_post
		logout
		upvote_last_post
		assert_equal 0, Post.last.vote_counter
	end

	test "should not downvote not logged in" do
		make_random_post
		logout
		downvote_last_post
		assert_equal 0, Post.last.vote_counter
	end

	test "should try to patch post not logged in and fail" do
		get '/logout'
		title = Post.last.title
		patch '/posts/' + Post.last.id.to_s,
			params: { post: { title: "batata", body: "2", category_id: categories(:two).id, author_id: users(:one).id } }
		assert_equal title, Post.last.title
	end

	test "should try to delete post not logged in and fail" do
		get '/logout'
		title = Post.last.title
		delete '/posts/' + Post.last.id.to_s
		assert_equal title, Post.last.title
	end

	test "should try to patch post logged in another account and fail" do
		make_random_post
		logout
		login_user :three # Not admin
		title = Post.last.title
		patch '/posts/' + Post.last.id.to_s,
			params: { post: { title: "3", body: "2", category_id: categories(:two).id } }
		assert_equal title, Post.last.title
	end

	test "should try to delete post logged in another account and fail" do
		make_random_post
		logout
		login_user :three # Not admin
		title = Post.last.title
		delete '/posts/' + Post.last.id.to_s
		assert_equal title, Post.last.title
	end

	test "should create comment on post" do
		make_random_post
		post '/comments',
			params: { comment: { text: 'ola', user_id: @user.id, post_id: Post.last.id, author_id: users(:one).id } }
		assert_response :redirect
		assert_equal 'ola', Comment.last.text
		assert_equal Post.last.id, Comment.last.commentable.id
	end

	test "should create comment on comment" do
		make_random_post
		post '/comments',
			params: { comment: { text: 'ola', user_id: @user.id, post_id: Post.last.id, author_id: users(:one).id } }
		root_comment = Comment.last
		post '/comments',
			params: { comment: { text: 'oi', user_id: @user.id, comment_id: Comment.last.id, author_id: users(:one).id } }
		assert_response :redirect
		assert_equal 'oi', Comment.last.text
		assert_equal root_comment.id, Comment.last.commentable.id
	end
end
