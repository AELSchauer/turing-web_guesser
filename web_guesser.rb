require 'sinatra'
require 'sinatra/reloader'

guesser = WebGuesser.new

get '/' do
  cheat = true?(params["cheat"])
  guess = params["guess"]
  if guesser.guess_tries == 0
    guesser = WebGuesser.new
  end
  user_message, tries_message = guesser.check_guess(guess)
  secret_number_message = guesser.cheat_mode_on?(cheat)
  erb :index, :locals => {
    :user_message => user_message,
    :secret_number_message => secret_number_message,
    :tries_message => tries_message
  }
end

class WebGuesser

  attr_reader :guess_tries

  def initialize
    @secret_number = rand(101)
    @guess_tries = 5
  end

  def check_guess(guess)
    if guess.nil? || guess.empty?
      user_message = ""
      tries_message = "#{@guess_tries} tries left."
    else
      diff = guess.to_i - @secret_number
      @guess_tries -= 1
      tries_message = ""
      if diff == 0
        user_message = "You got it right in #{5-@guess_tries} tries!"
        @guess_tries = 0
      elsif @guess_tries == 0
        user_message = "Sorry, you lose! Enter a new number to try again."
        @guess_tries = 0
      else
        extent = diff.abs >= 5 ? "way too" : "too"
        highlow = diff.abs == diff ? "high" : "low"
        user_message = "#{extent} #{highlow}!".capitalize
        tries_message = "#{@guess_tries} tries left."
      end
    end
    [user_message, tries_message]
  end

  def cheat_mode_on?(cheat)
    cheat ? "The secret number is #{@secret_number}." : ""
  end

end

def true?(statement)
  statement == "true"
end