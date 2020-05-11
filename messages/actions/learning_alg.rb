# frozen_string_literal: true

require 'singleton'
require './messages/actions/start_lesson.rb'
class Learning
  include Singleton
  attr_accessor :bot_options, :status, :words
  def initialize
    @bot_options = BotOptions.instance
    @status      = status
    @words       = words
  end

  def menu
    bot_options.send_message("Enter:\n /start_lesson - To start lesson\n /look_at_list - To look at the list of words in this lesson\n /reset_lesson - To return to main menu and to reset list of words")
  end

  def start_lesson
    StartLesson.new(words)
  end

  def look_at_list
    demonstrate_string = ''
    words.each do |row|
      demonstrate_string += row[0] + ' - ' + row[1] + "\n"
    end
    demonstrate_string += "----------\n /start_lesson - To start lesson\n /reset_lesson - To return to main menu and to reset list of words"
    bot_options.send_message(demonstrate_string)
  end
end
