# frozen_string_literal: true

require './db/db.rb'
require './operations/inline_markup_generator.rb'
class StartLesson
  attr_reader :words, :bot_options, :steps, :case_message, :writing_ex_words
  def initialize(words)
    @words            = words
    @bot_options      = BotOptions.instance
    @case_message     = case_message
    @steps            = 0
    @writing_ex_words = []
    bot_options.send_message("Lesson was started, to interrupt - enter /interrup_lesson\nlesson progress will be reset")
    start_lesson
  end

  def start_lesson
    bot_options.bot.listen do |message|
      @case_message = message
      loop do
        return false if message.text == '/interrup_lesson'
        break if words.empty?

        get_steps         unless words.empty?
        demonstrate_words unless words.empty?
        picking_exercise  unless words.empty?
      end
    end
  end

  def get_steps
    @steps = words.length >= 5 ? 4 : words.length - 1
  end

  def demonstrate_words
    # markup = MakeInlineMarkup.new(['Группа ВК', 'https://vk.com/pozor.brno'], ['Telegram Канал', 'https://t.me/pozor_brno']).get_link
    (0..steps).each do |i|
      bot_options.send_message("#{words[i][0]} - #{words[i][1]}") if i == 0
      edit_message("#{words[i][0]} - #{words[i][1]}") if i > 0
      sleep(1)
    end
 end

  def picking_exercise
    i = 0
    loop do
      break if i == steps

      variants = get_random_variant(words[i][1])
      p variants
      #   bottom_keyboard = MakeInlineMarkup.new(%w[Химия История Физика], %w[Биология Информатика], %w[Английский География], 'Закончить Ввод').get_board
      markup = MakeInlineMarkup.new([variants[0], variants[1]], [variants[2], variants[3]]).get_board
      p markup
      edit_message("Correct translation of the word #{words[i][0]}(use inline keyboard to enter answer, u have 10 seconds to answer)", markup)
      sleep(10)
      if check_answer(words[i][1])
        writing_ex_words << words[i]
        i += 1
      else
        edit_message("It's incorrect answer\n #{words[i]}")
      end
    end
  end

  def check_answer(correct)
    correct == case_message.text
  end

  def get_random_variant(correct_variant)
    variants = [correct_variant]
    all_ru_words_to_shuffle = Db.instance.get_all_ru
    (1..3).each do |_i|
      variants << all_ru_words_to_shuffle[rand(all_ru_words_to_shuffle.length - 1)]
    end
    variants.shuffle.flatten
  end

  def edit_message(text, keyboard = nil)
    p keyboard
    bot_options.bot.api.edit_message_text(chat_id: @case_message.from.id, message_id: @case_message.message_id + 1, text: text, reply_markup: keyboard)
  end
end
