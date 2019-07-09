Rails.application.routes.draw do

	resources :notifications

  get 'messages/create'
	get 'messages/destroy'
	
  get 'chats/show', to: 'chat_rooms#show'
	get 'chats', to: 'chat_rooms#index'

	post 'messages/create'
	post 'messages/destroy'
	
	resources :sessions, only: [:new, :create, :destroy]
	
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
	
	resources :users
  resources :categories

	resources :posts do
    resources :comments
  end

  resources :comments do
    resources :comments
	end
	
	resources :friendships

	post 'friendships/accept', to: 'friendships#accept'
	post 'friendships/reject', to: 'friendships#reject'
	
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
	get 'logout', to: 'sessions#destroy', as: 'logout'
	
	get 'admin', to: 'users#index', as: 'admin'

	root 'posts#index'

	post 'upvote', to: 'votes#upvote', as: 'upvote'
	post 'downvote', to: 'votes#downvote', as: 'downvote'

	post 'comments/new', to: 'comments#create'

end
