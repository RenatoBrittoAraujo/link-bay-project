def login_user(user)
	user = users(user)
	post '/sessions',
		params: { nick_or_email: user.email, password: 'secret123' }
	user
end

def signin_user(user)
	user = users(user)
	post '/users',
		params: { user: { email: user.email, password: 'secret123', password_confirmation: 'secret123', nick: user.nick, name: user.name }}
	user
end

def make_random_post
	post = Post.new
	post.title = "Gzuis humilia o satanas"
	post.body = "owwww eiiss oww ie"
	post.category = categories(:one)
	post.author = users(:one)
	post '/posts',
		params: { post: { title: post.title, body: post.body, category_id: post.category.id, author_id: post.author.id } }
	post
end

def logout
	get '/logout'
end

def upvote_last_post
	post '/upvote',
		params: { vote: { post_id: Post.last.id } }
end

def downvote_last_post
	post '/downvote',
		params: { vote: { post_id: Post.last.id } }
end

def make_friendship(user1, user2)
	login_user user1
	post '/friendships',
		params: { friendship: { sender_id: users(user1).id, receiver_id: users(user2).id } }
	logout
	login_user user2
	post '/friendships/accept',
		params: { friendship: { friendship_id: Friendship.last.id } }
	logout	
end