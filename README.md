# Link Bay

Deployed to heroku at: https://fierce-depths-20461.herokuapp.com/
Original repository: https://gitlab.com/link-bay-project/link-bay

## About the project

When you want to learn something new, you search the internet and find a huge amount of links, of varying degrees of quality. Which of them to pick? Which of the provides the best deal for you? How can you curate through content without having to search much or having to rely on the opinion of random blogs and forums? 

This is where Link Bay comes in. We want to help learners save time and effort, by creating a community that share their knowledge by providing links in a democratic and trasparent manner.

## The techical stuff

Rails version: 5.2.3
Ruby version: 2.6.0

For basic operation
```
bundle
rails s
```

For auto-reloading when working with front-end
- On a new terminal, do and keep running
```
bundle exec guard
```
- On other terminal write
```
guard init livereload
```
- Install chrome extension: https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=pt-BR

For updating the post weights in the database (development only)
- Set crontab file
```
whenever -i
```
- See the logs at log/whenever.log
- You may manually alter/delete the crontab with
```
crontab -e
```

In production, using Heroku's Scheduler addon, updating posts weight every hour

For testing
- Prepare the testing database by adding the fixtures to it
```
rake db:test:prepare
```
- Pray for all of them to pass
```
rails test
```
