# frozen_string_literal: true

require 'dotenv'
Dotenv.load('./.env')

class MessageResponder
  attr_reader :bot, :message, :db, :user_input, :id
  def call(bot:, message:, db:, user_input:)
    @bot = bot
    @message = message
    @user_input = user_input
    @db         = db
    @id         = ENV['USER_ID'].to_i
    respond
  end

  def respond
    case user_input
    when '/start'
      main_menu
    when '/new'
      start_learning
    when '/repeat'
      repeat_learned
    when '/update_db'
      update_db
    when '/progress'
      show_progress
    end
  end

  def main_menu
    send_message("Choose right option:\n/new - start learning new words\n/repeat - repeat already learned words\n/update_db - update database by adding new words from spreadseet\n/progress - get learning progress message")
  end

  def update_db
    db.parse_spreadsheet
  end

  def start_learning; end

  def send_message(text)
    bot.api.send_message(chat_id: id, text: text)
  end
end
