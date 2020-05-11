# frozen_string_literal: true

class MakeInlineMarkup
  def initialize(*inline_items)
    @inline_items = inline_items
  end

  def get_markup
    kb = []
    markup = []
    (0..@inline_items.length - 1).each do |i|
      kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: (@inline_items[i][0]).to_s, callback_data: (@inline_items[i][1]).to_s)
    end
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def get_link
    kb = []
    markup = []
    (0..@inline_items.length - 1).each do |i|
      kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: (@inline_items[i][0]).to_s, url: (@inline_items[i][1]).to_s)
    end
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def get_board
    markup = []
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: @inline_items)
  end

  def delete_board
    markup = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
  end
  end
