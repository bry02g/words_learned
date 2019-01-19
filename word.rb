require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/words.db")

class Word
  include DataMapper::Resource
  property :id, Serial
  property :word, Text
  property :meaning, Text
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the word table
Word.auto_upgrade!
