# frozen_string_literal: true

require 'singleton'
require './messages/actions/lesson_algorithm/start_lesson.rb'
require './db/db.rb'
require './operations/inline_markup_generator.rb'

class ExercisesForLesson
  attr_reader :case_bot_options, :steps, :writing_ex_words, :words
  include Singleton
  def initialize
    @words            = Learning.instance.words
    @steps            = 0
    @writing_ex_words = []
    @case_bot_options = CaseBotOptions.instance
  end

  def get_steps
    @steps = words.length >= 5 ? 4 : words.length - 1
  end

  def demonstrate_words
    # markup = MakeInlineMarkup.new(['Группа ВК', 'https://vk.com/pozor.brno'], ['Telegram Канал', 'https://t.me/pozor_brno']).get_link
    (0..steps).each do |i|
      case_bot_options.send_message("#{words[i][0]} - #{words[i][1]}") if i == 0
      case_bot_options.edit_message("#{words[i][0]} - #{words[i][1]}") if i > 0
      sleep(1)
    end
  end

  def picking_exercise
    i = 0
    loop do
      break if i == steps
      variants = get_random_variant(words[i][1])
      #   bottom_keyboard = MakeInlineMarkup.new(%w[Химия История Физика], %w[Биология Информатика], %w[Английский География], 'Закончить Ввод').get_board
      markup = []
      markup = MakeInlineMarkup([variants[0], variants[1]], [variants[2], variants[3]]).get_board
      if i == 0 
        case_bot_options.delete_message 
        case_bot_options.send_message("Correct translation of the word(use inline keyboard to enter answer, u have 10 seconds to answer)\n\n#{words[i][0]}", markup)
      elsif i > 0 && i != steps-1
        case_bot_options.delete_message(1)
        case_bot_options.send_message("Correct translation of the word(use inline keyboard to enter answer, u have 10 seconds to answer)\n\n#{words[i][0]}", markup)
      elsif i == steps-1
        
      end
      case_bot_options.edit_message("Correct translation of the word(use inline keyboard to enter answer, u have 10 seconds to answer)\n\n#{words[i][0]}", markup)
      sleep(10)
      if check_answer(words[i][1])
        writing_ex_words << words[i]
        i += 1
      else
        case_bot_options.edit_message("It's incorrect answer\n #{words[i]}")
      end
    end
  end

  def check_answer(correct)
    correct == case_bot_options.message.text
  end

  def get_random_variant(correct_variant)
    variants = [correct_variant]
    all_ru_words_to_shuffle = Db.instance.get_all_ru
    (1..3).each do |_i|
      variants << all_ru_words_to_shuffle[rand(all_ru_words_to_shuffle.length - 1)]
    end
    variants.shuffle.flatten
  end
end
