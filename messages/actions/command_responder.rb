# frozen_string_literal: true

require './db/db'

class Invoker
  attr_reader :history

  def execute(cmd)
    @history ||= []
    @history << cmd.execute
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
    send_message("Choose right option:\n/new - start learning new words\n/repeat - repeat already learned words\n/update_db - update database by adding new words from spreadseet\n/progress - get learning progress message")
  end

  def new_list
    send_message('new list command')
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

  def send_message(text)
    BotOptions.instance.send_message(text)
  end
end

class AnswerClient
  def initialize
    @receiver = Receiver.new
    @invoker  = Invoker.new
  end

  def respond_to(cmd)
    case cmd
    when '/start' then @invoker.execute(StartCommand.new(@receiver))
    when '/new' then @invoker.execute(NewCommand.new(@receiver))
    when '/repeat' then @invoker.execute(RepeatCommand.new(@receiver))
    when '/update_db' then @invoker.execute(UpdateDbCommand.new(@receiver))
    when '/progress' then @invoker.execute(ProgressCommand.new(@receiver))
    end
  end
end
