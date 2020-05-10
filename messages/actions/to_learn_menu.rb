# frozen_string_literal: true

require './operations/status_constants.rb'
require './messages/actions/to_learn_menu.rb'
require './messages/actions/learning_alg.rb'
require './db/db.rb'

class ToLearn
  attr_reader :status, :bot_options, :user_input
  def initialize(status: Status::UNLEARNED)
    @status      = status
    @bot_options = BotOptions.instance
    @user_input  = bot_options.message.text
  end

  def send_request
    bot_options.send_message('Enter number of words you want to learn for now (from 10 to 25 recomended)')
  end

  def get_amount
    amount = user_input
    words = Db.instance.get_words(amount.to_i, status)
    to_learn = Learning.instance
    to_learn.status = status
    to_learn.words  = words
    to_learn.menu
    # Learning.new.menu(Db.instance.get_words(amount, status))
  end
end
