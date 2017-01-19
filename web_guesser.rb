require 'sinatra'
require 'sinatra/reloader'

SECRET_NUMBER = rand(101)

get '/' do
  guess = params["guess"].to_i
  user_message, number_message = check_guess(guess)
  erb :index, :locals => {:user_message => user_message, :number_message => number_message}
end

def check_guess(guess)
  user_message = ""
  number_message = "The secret number is #{SECRET_NUMBER}."
  diff = guess - SECRET_NUMBER
  if diff == 0
    user_message = "You got it right!"
    number_message = ""
  else
    way = diff.abs >= 5 ? "way " : ""
    highlow = diff.abs == diff ? "high" : "low"
    user_message = "#{way}too #{highlow}!".capitalize
  end
  [user_message, number_message]
end