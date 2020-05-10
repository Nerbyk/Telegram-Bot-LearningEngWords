# frozen_string_literal: true

require 'dotenv'
require './messages/actions/command_responder.rb'
Dotenv.load('./.env')

class MessageResponder
  attr_reader :bot, :message, :user_input, :id
  def call(bot:, message:, user_input:)
    @bot        = bot
    @message    = message
    @user_input = user_input
    @id         = ENV['USER_ID'].to_i
    respond
  end

  def respond
    client = AnswerClient.new
    client.respond_to(user_input)
  end
end