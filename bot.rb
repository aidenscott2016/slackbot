# use karl's chat-adapter library
require 'chat-adapter'
# also use the local HerokuSlackbot class defined in heroku.rb
require './heroku'

require 'net/http'

require 'uri'

require 'unirest'


base_url = "http://6c56750d.ngrok.io"

# if we're on our local machine, we want to test our bot via shell, but when on
# heroku, deploy the actual slackbot.
# 
# Feel free to change the name of the bot here - this controls what name the bot
# uses when responding.
if ARGV.first == 'heroku'
  bot = HerokuSlackAdapter.new(nick: 'echobot')
else
  bot = ChatAdapter::Shell.new(nick: 'echobot')
end

# Feel free to ignore this - makes logging easier
log = ChatAdapter.log

# Do this thing in this block each time the bot hears a message:
bot.on_message do |message, info|
  # ignore all messages not directed to this bot
  case
    when message.start_with?('voice')
      command, announcement = message.split(': ', 2)
    when message.include?('php fatal errors')
      command = 'error'
    else
      next
  end

  announcement = URI.escape(announcement)
  case command
    when 'voice'
      uri = "#{base_url}/Office/say/#{announcement}/Brian/80"
    when 'error'
      # uri = URI.parse("#{base_url}/#{command}/#{errorlocation}/#{announcement}")
  end


  Unirest.get(uri) { | response |
  }
  
  "@#{info[:user]}: saying  #{announcement}"
end


=begin
if command == 'error'
 d
else
  uri = URI.parse("http://6c56750d.ngrok.io/#{command}/#{URI.escape(announcement)}")
end
=end


# actually start the bot
bot.start!
