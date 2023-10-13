require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = [];
    @letters += Array.new(10) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    test_json = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    @results = JSON.parse(test_json)
    @english_word_or_not = @results['found']

    @attempt = params[:word].split('')
    @letters = params[:letters].downcase.split('')

    @result_hash = {
      score: 0,
      message: 'Not in the grid.'
    }

    @in_grid = (@attempt - @letters).empty?

    if @in_grid == false
      @result_hash[:score] = 0
      @result_hash[:message] = "Sorry but #{params[:word]} cannot be built out of #{@letters.join(', ')}"
    elsif @in_grid == true
      if @english_word_or_not == false
        @result_hash[:score] = 0
        @result_hash[:message] = "Sorry but #{params[:word]} is not an English word."
      elsif @english_word_or_not == true
        @result_hash[:score] = 100
        @result_hash[:message] = "Congratulations! #{params[:word]} is a valid English word. You win!"
      end
    end

    @result_hash
  end
end
