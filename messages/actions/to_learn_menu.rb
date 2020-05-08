# frozen_string_literal: true

require './operations/status_constants.rb'
require './messages/actions/to_learn_menu.rb'

class ToLearn < MessageResponder
  attr_reader :bot, :message, :db, :user_input, :id
  def call(bot:, message:, db:, user_input:)
    super(bot, message, user_input, db, id)
    get_amount
  end

  def get_amount(status = Status::UNLEARNED)
    send_message('Enter number of words you want to learn for now (from 10 to 25 recomended)')
    amount = user_input
    Learning.new.menu(db.get_words(amount, status))
  end
end
