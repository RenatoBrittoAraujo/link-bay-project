desc "This task is called by the Heroku scheduler add-on"
task :update_posts_weights => :environment do
	puts "POST UPDATER (#{Time.now}) updating weights on posts"
	Post.all.each do |post|
		if post.weight.nil?
			post.weight = 0
		else
			post.weight = post.weight + 1
		end
		post.save
	end
end