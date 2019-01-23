echo 'starting sass reloading...'
sass --watch public/app.sass:public/app.css &
echo 'starting application...'
rerun bundle exec ruby app.rb
echo 'done'
