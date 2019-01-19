require 'sinatra'
require 'data_mapper'
require 'haml'

require_relative 'word'
require_relative 'lookup'
# route for description of application
get '/' do
   haml :index  
end

# route to display all the words entered in 
# the database
get '/words' do
    @words = Word.all
    haml :words
end

# route to handle the creation of new words
# return a form asking for the word to add to database
get '/words/new' do
    haml :new 
end

# when the submit button from get '/words/new' page is pressed
# this post route is called creating and adding the word to the 
# database only if a word was entered and found in dictionary
# then redirect to word wall
post '/words/create' do
    if params[:word]
        w = Word.new
        w.word = params[:word]
        lookup = Lookup.new(w.word)
        w.meaning = lookup.search
        w.save
    end
	redirect "/words"
end

# shows some statistics on words learned
get '/words/stats' do 
    haml :stats
end

# this route get called when the user presses the x delete button
# removing that word from the database
get '/words/delete/:id' do
    if params[:id]
        id = params[:id].to_i
        w = Word.get(id)
        w.destroy
    end
    redirect "/words"
end 
