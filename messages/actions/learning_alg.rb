# frozen_string_literal: true

class Learning < MessageResponder
  attr_reader :bot, :message, :db, :user_input, :id
  def call(bot:, message:, db:, user_input:)
    super(bot, message, user_input, db, id)
  end

  def menu(words)
    # TODO: menu items -
    # 1. Start lessond
    # 2. Look at list
    # 3. Return to menu
  end
end
