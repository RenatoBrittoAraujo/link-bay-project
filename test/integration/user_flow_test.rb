require 'test_helper'
require_relative '../helpers/integration_helpers'

class UserFlowTest < ActionDispatch::IntegrationTest
	
  test "should not signup because invalid password confirmation" do
    post '/users',
      params: { user: { email: 'clebinho@gmail.com', password: 'secret123', password_confirmation: 'secret122', nick: 'clebs', name: 'Clebbersson' }}
		assert_response :success
  end

	test "should signup" do
    get '/users/new'
    assert_response :success
    User.find_by(id: users(:one).id).delete
		signin_user :one
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "div", "Welcome aboard to Link Bay!"
  end

  test "should be logged in after signup" do
    User.find_by(id: users(:one).id).delete
		signin_user :one
    get '/posts/new' # A user can only access 'get /posts/new' if logged in
    assert_response :success
  end

  test "should not be logged in" do
    get '/posts/new'
    assert_response :redirect
  end

  test "should signin and log out" do
    User.find_by(id: users(:one).id).delete
		signin_user :one
    get '/posts/new'
    assert_response :success
    logout
    assert_response :redirect
    follow_redirect!
    get '/posts/new'
    assert_response :redirect
  end

  test "should login and logout" do
    get '/login'
    assert_response :success
		login_user :one
		follow_redirect!
		logout
		follow_redirect!
	end
	
	test "should not have access to admin restricted area" do
		login_user :one # Not admin
		get '/admin'
		assert_response :redirect
	end

	test "should have access to admin restricted area" do
		login_user :two # Is admin
		get '/admin'
		assert_response :success
	end

	test "should send friendship request" do
		login_user :one
		get '/users/2'
		assert_response :success
		assert_equal 2, Friendship.count
		post '/friendships',
			params: { friendship: { sender_id: users(:one).id, receiver_id: users(:two).id } }
		assert_equal 3, Friendship.count
	end

	test "should send and accept friendship request" do
		login_user :one
		post '/friendships',
			params: { friendship: { sender_id: users(:one).id, receiver_id: users(:two).id } }
		assert_equal 3, Friendship.count
		logout
		login_user :two
		assert_equal false, Friendship.last.accepted
		post '/friendships/accept',
			params: { friendship: { friendship_id: Friendship.last.id } }
		assert_equal true, Friendship.last.accepted
	end

	test "should send and reject friendship request" do
		login_user :one
		post '/friendships',
			params: { friendship: { sender_id: users(:one).id, receiver_id: users(:two).id } }
		assert_equal 3, Friendship.count
		logout
		login_user :two
		assert_equal false, Friendship.last.accepted
		post '/friendships/reject',
			params: { friendship: { friendship_id: Friendship.last.id } }
		assert_equal 2, Friendship.count
	end

	test "should send message to friend" do
		make_friendship :one, :two
		login_user :one
		get '/chats/show?id=' + Friendship.last.id.to_s
		assert_response :success
		get '/messages/create',
			params: { message: { user_id: users(:one).id, chat_room_id: ChatRoom.last.id, body: 'HEY' } }
		assert_equal 'HEY', Message.last.body
	end
end
