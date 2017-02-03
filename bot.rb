# use karl's chat-adapter library
require 'chat-adapter'
# also use the local HerokuSlackbot class defined in heroku.rb
require './heroku'

require 'net/http'

require 'uri'

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
  unless message.start_with? 'voice'
    next # don't process the next lines in this block
  end

  botname, announcement = message.split(': ', 2)
  uri = URI.parse("http://21230bab.ngrok.io/Office/say/#{URI.escape(announcement)}/Geraint/")
  Net::HTTP.get_response(uri)
  


  # Conditionally send a direct message to the person saying whisper
  if message == 'echobot: whisper'
    # log some info - useful when something doesn't work as expected
    log.debug("Someone whispered! #{info}")
    # and send the actual message
    bot.direct_message(info[:user], "whisper-whisper")
  end

  # split the message in 2 to get what was actually said.
  
  # answer the query!
  # this bot simply echoes the message back
  "@#{info[:user]}: saying  #{announcement}"
end

# actually start the bot
bot.start!
