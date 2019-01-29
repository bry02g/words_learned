require 'sinatra'
require 'data_mapper'
require 'haml'
require 'chartkick'

require_relative 'word'
require_relative 'lookup'


# route for description of application
get '/' do
   haml :index  
end

# route to display all the words entered in 
# the database
get '/words' do
    if params[:sort]
       @method = params[:sort]
       if @method == 'favorite'
           @words = Word.all(favorite: true)
       elsif @method == 'date'
           @words = Word.all.sort {|x,y| x <=> y}
       elsif @method == 'alph'
           @words = Word.all.sort {|x,y| x.word <=> y.word}
       elsif @method == 'length'
           @words = Word.all.sort{|x,y| x.word.length <=> y.word.length}
       end
    else
        @method = 'default'
        @words = Word.all.sort {|x,y| y.created_at <=> x.created_at}
    end
    @numOfWords = Word.all.size
    if params[:json]
        return @words.to_json
    else 
        haml :words
    end
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
        @w = Word.new
        @w.word = params[:word]
        lookup = Lookup.new(@w.word)
        @w.meaning = lookup.search
        @w.save
    end
    if params[:json]
        return @w.to_json
    else 
	    redirect "/words"
    end
end

# shows some statistics on words learned
get '/words/stats' do 
    @data = Word.all.group_by_day{|w| w.created_at}
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
    if params[:json]
        return '{deleted: true}'
    else 
        redirect "/words"
    end
end 

# this route is called to mark a word
# as favorite
get '/words/favorite/:id' do
    if params[:id]
        w = Word.get(params[:id].to_i)
        w.favorite = true
        w.save
    end
    redirect '/words'
end

# this route is called to un like a word
# and chage its state in the database
get '/words/unlike/:id' do
    if params[:id]
        w = Word.get(params[:id].to_i)
        w.favorite = false
        w.save
    end

    redirect '/words'
end
