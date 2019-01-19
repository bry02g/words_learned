require 'rest-client'
require 'json'


class Lookup 
  @@app_id = 'c2e26230'
  @@app_key = '252c0bd5b08ba41b2d90be43f89753ab'

  def initialize(word)
    @word = word
    @language = 'en'
    @url = "https://od-api.oxforddictionaries.com/api/v1/"
  end

  def search
    lem_url = @url  + 'inflections/' + @language + '/' + @word.downcase
    header =  {'app_id' => @@app_id, 'app_key' => @@app_key}
    begin 
      response = RestClient.get lem_url, header
      result = JSON.parse(response.body)
      search_term = result['results'][0]['lexicalEntries'][0]['inflectionOf'][0]['text'] 
      puts "we got inflections of #{search_term}"

      entries_url = @url + 'entries/' + @language + '/' + search_term.downcase
      response = RestClient.get entries_url, header
      result = JSON.parse(response.body)
      meaning = result['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]
      puts "the meaning is #{meaning}"

      return meaning 

    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    return "unable to find definition"
  end
end


