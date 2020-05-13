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

  private

  def create
    db.create_table? table do
      String :eng
      String :ru
      String :status
    end
    dataset = db[table]
  end

  public

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
    # returns word pairs according to spec. status
    words = words.map do |row|
      row.delete(row) if row[2] != status
      row[0..1]
    end
    lesson_words = []
    # returns spec. amount of word pairs randomly chosen  without matching
    (1..amount).each do |_i|
      random_number = rand(words.length - 1)
      lesson_words << words[random_number]
      words.delete(words[random_number])
    end
    lesson_words
  end

  def get_all_ru
    dataset.select_map(%i[ru])
  end
end
