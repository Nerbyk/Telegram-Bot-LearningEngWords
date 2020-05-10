# frozen_string_literal: true

require 'logger'
require 'telegram/bot'
require 'dotenv'

Dotenv.load('./.env')

require './messages/responder.rb'
require './messages/button_responder.rb'
require './db/db.rb'

class BotOptions
  attr_accessor :bot, :message
  include Singleton

  def initialize
    @bot     = bot
    @message = message
  end

  def send_message(text)
    bot.api.send_message(chat_id: message.from.id, text: text)
  end

  def delete_last_message
    bot.api.delete_message(chat_id: message.from.id, message_id: message.message_id - 1)
  end
end

Telegram::Bot::Client.run(ENV['TOKEN']) do |bot|
  bot.listen do |message|
    bot_options = BotOptions.instance
    bot_options.bot = bot
    bot_options.message = message
    if message.from.id == ENV['USER_ID'].to_i
      begin
        case message
        when Telegram::Bot::Types::CallbackQuery
          message_button = MessageButton.new
          message_button.call(bot: bot, message: message)
        else

          MessageResponder.new(bot: bot_options.bot, message: bot_options.message)
        end
      rescue StandardError => e
        bot_options.send_message("Error: #{e}")
        # prs_log.error "User_id #{message.from.id}, User name = #{message.from.username} Error = #{e}"
        p e
      end
    else
      bot_options.send_message('Sorry, but I am a private bot, for more information u can write to my owner - @nerby1')
    end
  end
end
