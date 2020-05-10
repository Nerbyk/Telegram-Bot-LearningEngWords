# frozen_string_literal: true

require 'logger'
require 'telegram/bot'
require 'dotenv'

Dotenv.load('./.env')

require './messages/responder.rb'
require './messages/button_responder.rb'

Telegram::Bot::Client.run(ENV['TOKEN']) do |bot|
  bot.listen do |message|
    if message.from.id == ENV['USER_ID'].to_i
      begin
        case message
        when Telegram::Bot::Types::CallbackQuery
          message_button = MessageButton.new
          message_button.call(bot: bot, message: message)
        else
          message_responder = MessageResponder.new
          message_responder.call(bot: bot, message: message, user_input: message.text)
        end
      rescue StandardError => e
        bot.api.send_message(chat_id: message.from.id, text: "Error: #{e}")
        # prs_log.error "User_id #{message.from.id}, User name = #{message.from.username} Error = #{e}"
        p e
      end
    else
      bot.api.send_message(chat_id: message.from.id, text: 'Sorry, but I am a private bot, for more information u can write to my owner - @nerby1')
    end
  end
end
