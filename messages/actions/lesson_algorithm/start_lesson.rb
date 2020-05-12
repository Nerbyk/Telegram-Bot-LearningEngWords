# frozen_string_literal: true

require 'singleton'
require './db/db.rb'
require './operations/inline_markup_generator.rb'
require './messages/actions/lesson_algorithm/exercises.rb'

class StartLessonOptions
  attr_reader :bot_options, :steps, :writing_ex_words
  def initialize
    @words            = Learning.instance.words
    @bot_options      = BotOptions.instance
    @steps            = 0
    @writing_ex_words = []
    StartLesson.instance.start_lesson
  end
end

class StartLesson < StartLessonOptions
  include Singleton
  attr_reader :words, :exercise, :bot_options, :steps, :case_message, :writing_ex_words
  def initialize
    super
    @exercise = ExercisesForLesson.instance
  end

  def start_lesson
    bot_options.send_message("Lesson was started, to interrupt - enter /interrup_lesson\nlesson progress will be reset")
    bot_options.bot.listen do |message|
      loop do
        return false if message.text == '/interrup_lesson'
        break if words.empty?

        exercise.get_steps         unless exercise.words.empty?
        exercise.demonstrate_words unless exercise.words.empty?
        exercise.picking_exercise  unless exercise.empty?
      end
    end
  end
end
