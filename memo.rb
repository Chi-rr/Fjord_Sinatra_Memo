# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "db"

class Memo
  def create(memo_name, memo_content)
    Database.new.create_row(memo_name, memo_content)
  end

  def delete(id)
    Database.new.delete_row(id)
  end

  def update(id, memo_name, memo_content)
    delete(id)
    Database.new.update_row(id, memo_name, memo_content)
  end

  def self.find(id)
    Database.new.row(id)
  end

  def self.index
    Database.new.rows
  end
end
