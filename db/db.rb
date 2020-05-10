# frozen_string_literal: true

require 'sqlite3'
require 'sequel'
require 'singleton'
require './db/spreadsheet/spreadsheet_parser.rb'
require './operations/status_constants.rb'

class Db
  include Singleton
  attr_reader :db, :dataset, :table
  def initialize
    @db      = Sequel.sqlite('./db/my_dictionary.db')
    @table   = :words_list
    @dataset = create
  end

  def create
    db.create_table? table do
      String :eng
      String :ru
      String :status
    end
    dataset = db[table]
  end

  def parse_spreadsheet
    array_of_new_words = Spreadsheet.new
    array_of_new_words = array_of_new_words.get_words
    array_of_old_words = dataset.select_map(%i[eng ru])
    array_of_new_words -= array_of_old_words unless array_of_old_words.nil?
    array_of_new_words.each do |row|
      dataset.insert(eng: row[0], ru: row[1], status: Status::UNLEARNED)
    end
  end

  def get_words(amount, status)
    words = dataset.select_map(%i[eng ru status])
    words = words.map { |row| row.delete(row) if row[2] != status }.uniq
    lesson_words = []
    (1..amount.to_i).each do |_i|
      random_number = rand(words.length - 1)
      lesson_words << words[random_number]
    end
    p lesson_words
    lesson_words
    # TODO: return array of randomly chosen rows, length == amount, sort by status
  end
end
