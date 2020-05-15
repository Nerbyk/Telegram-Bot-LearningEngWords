# frozen_string_literal: true

require 'singleton'
require './messages/actions/lesson_algorithm/exercises.rb'

class CaseBotOptions
  include Singleton
  attr_accessor :bot, :message
  def initialize
    @bot     = bot
    @message = message
  end

  def send_message(text, markup = nil)
    bot.api.send_message(chat_id: message.from.id, text: text, reply_markup: markup)
  end

  def delete_last_message(message_index = 0)
    bot.api.delete_message(chat_id: message.from.id, message_id: message.message_id - message_index)
  end

  def edit_message(text, keyboard = nil)
    puts("keyboard: #{keyboard}\nmessage.message_id: #{message.message_id}\ntext: #{text}")
    bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message_id + 1, text: text)
  end
end

class StartLesson
  attr_reader :exercise, :case_bot_options, :words
  def initialize
    @case_bot_options = CaseBotOptions.instance
    @exercise         = ExercisesForLesson.instance
    @words            = Learning.instance.words
    start_lesson
  end

  def start_lesson
    case_bot_options.bot = BotOptions.instance.bot
    BotOptions.instance.send_message("Lesson was started, to interrupt - enter /interrup_lesson\nlesson progress will be reset")
    case_bot_options.bot.listen do |message|
      case_bot_options.message = message

      loop do
        return false if message.text == '/interrup_lesson'
        break if words.empty?

        exercise.get_steps         unless exercise.words.empty?
        exercise.demonstrate_words unless exercise.words.empty?
        exercise.picking_exercise  unless exercise.words.empty?
      end
    end
  end
end
