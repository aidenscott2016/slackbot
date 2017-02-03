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
  if message.start_with? 'voice'
    botname, announcement = message.split(': ', 2)
  elsif message.include? 'php fatal errors'
    if message.include? 'secure_error_log'
      announcement = 'Emergency! Emergency! Fatal error detected on secure'
    elsif message.include? 'test_error_log'
      announcement = 'Oops... Not to worry too much, but an error was detected on test'
    elsif message.include? 'demo_error_log'
      announcement = 'Excuse me, but I have detected an error on demo'
    else
      announcement = 'I apologise, but I need to make you aware that I have detected an error but I do not know what it is'
    end
  end

  "@#{info[:user]}: saying  #{announcement}"
  uri = URI.parse("http://21230bab.ngrok.io/Office/say/#{URI.escape(announcement)}/Brian/60")
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
