# frozen_string_literal: true

require 'bundler'
Bundler.require

class Spreadsheet
  attr_reader :session, :spreadsheet, :worksheet
  def initialize
    @session = GoogleDrive::Session.from_service_account_key('client_secret.json')
    @spreadsheet = session.spreadsheet_by_title('Ruby voc')
    @worksheet = spreadsheet.worksheets.first
  end

  def get_words
    return_array = worksheet.rows
    return_array = return_array.map do |row|
      row.map do |column|
        column = column.downcase.gsub(',', ';').chomp
        column
      end
    end
    return_array
  end
end
