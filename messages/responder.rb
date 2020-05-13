# frozen_string_literal: true

require 'dotenv'
require './messages/actions/command_responder.rb'
Dotenv.load('./.env')

class MessageResponder
  attr_reader :bot, :message, :user_input, :id
  def initialize(bot:, message:)
    @bot        = bot
    @message    = message
    @user_input = message.text
    @id         = ENV['USER_ID'].to_i
    respond
  end

  private

  def respond
    client = AnswerClient.new
    client.respond_to(user_input)
  end
end
