require 'data_mapper'
require 'dm-timestamps'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/words.db")

class Word
  include DataMapper::Resource
  property :id, Serial
  property :word, Text
  property :meaning, Text
  property :favorite, Boolean
  property :created_at, Date

  def get_date
    return self.created_at.strftime("%m/%d/%Y")
  end

end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the word table
Word.auto_upgrade!
