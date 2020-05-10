# frozen_string_literal: true

require 'dotenv'
require './messages/actions/command_responder.rb'
Dotenv.load('./.env')

class MessageResponder
  attr_reader :bot, :message, :db, :user_input, :id
  def call(bot:, message:, db:, user_input:)
    @bot        = bot
    @message    = message
    @user_input = user_input
    @db         = db
    @id         = ENV['USER_ID'].to_i
    respond
  end

  def respond
    client = AnswerClient.new(bot: bot, message: message, db: db, id: id)
    client.respond_to(user_input)
  end

  def send_message(text)
    bot.api.send_message(chat_id: id, text: text)
  end
end
