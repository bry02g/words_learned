echo 'starting sass reloading...'
sass --watch public/css/app.sass:public/css/app.css &
echo 'starting application...'
rerun bundle exec ruby app.rb
echo 'done'
