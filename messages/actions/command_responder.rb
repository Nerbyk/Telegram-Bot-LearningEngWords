# frozen_string_literal: true

require './db/db'
require './messages/actions/to_learn_menu.rb'
require './messages/actions/learning_alg.rb'
require 'singleton'

class Invoker
  include Singleton
  attr_reader :history, :requests

  def execute(cmd)
    @history ||= []
    @history << cmd.execute
    @requests ||= []
    @requests << BotOptions.instance.message.text
  end
end

class Command
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def execute
    raise NotImplementedError
  end
end

class StartCommand < Command
  def execute
    request.start
  end
end

class NewCommand < Command
  def execute
    request.new_list
  end
end

class NewGetCommand < Command
  def execute
    request.new_list_get_amount
  end
end

class StartLessonCommand < Command
  def execute
    request.start_lesson
  end
end

class LookLessonWordsCommand < Command
  def execute
    request.look_at_list
  end
end

class ResetLessonCommand < Command
  def execute
    request.reset_lesson
  end
end

class RepeatCommand < Command
  def execute
    request.repeat
  end
end

class UpdateDbCommand < Command
  def execute
    request.update_db
  end
end

class ProgressCommand
  def execute
    request.progress
  end
end

class Receiver
  def start
    BotOptions.instance.send_message("Choose right option:\n/new - start learning new words\n/repeat - repeat already learned words\n/update_db - update database by adding new words from spreadseet\n/progress - get learning progress message")
  end

  def new_list
    ToLearn.new.send_request
  end

  def new_list_get_amount
    ToLearn.new.get_amount
  end

  def start_lesson
    if Learning.instance.words.nil?
      BotOptions.instance.send_message('you can\'t  use this command, while list of words wasn\'t initialized')
    else
      if Invoker.instance.requests.last == '/look_at_list'
        BotOptions.instance.delete_last_message
      end
      StartLesson.new.item
    end
  end

  def look_at_list
    if Learning.instance.words.nil?
      BotOptions.instance.send_message('you can\'t use this command, while list of words wasn\'t initialized')
    else
      CheckLesson.new.item
    end
  end

  def reset_lesson
    Learning.instance.words = nil
    Learning.instance.status = nil
    start
  end

  def repeat
    send_message('repeat message entered')
  end

  def update_db
    Db.instance.parse_spreadsheet
    send_message('database updated, new words were uploaded.')
    start
  end

  def progress
    send_message('progress command entered')
  end
end

class AnswerClient
  def initialize
    @receiver = Receiver.new
    @invoker  = Invoker.instance
  end

  def respond_to(cmd)
    case cmd
    when '/start'        then @invoker.execute(StartCommand.new(@receiver))
    when '/new'          then @invoker.execute(NewCommand.new(@receiver))
    when '/repeat'       then @invoker.execute(RepeatCommand.new(@receiver))
    when '/update_db'    then @invoker.execute(UpdateDbCommand.new(@receiver))
    when '/progress'     then @invoker.execute(ProgressCommand.new(@receiver))
    when '/start_lesson' then @invoker.execute(StartLessonCommand.new(@receiver))
    when '/look_at_list' then @invoker.execute(LookLessonWordsCommand.new(@receiver))
    when '/reset_lesson' then @invoker.execute(ResetLessonCommand.new(@receiver))
    else
      if @invoker.requests.last == '/new'
        @invoker.execute(NewGetCommand.new(@receiver))
      end
    end
  end
end
