require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      email = 'jaquimzin@gmail.com'
			nick = 'jaquimzin'
			name = 'Joaquim Silva'
      post '/users', params: { 
        user: { email: email, name: name, nick: nick, password: 'secret123', password_confirmation: 'secret123' } 
      }
    end
    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { admin: @user.admin, email: @user.email, name: @user.name, nick: @user.nick, password: 'secret', password_confirmation: 'secret', summary: @user.summary } }
    assert_redirected_to root_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to root_path
  end
end
