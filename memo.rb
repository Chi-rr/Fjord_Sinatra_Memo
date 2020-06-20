# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "db"

class Memo
  def create(params)
    Database.new.create_row(params)
  end

  def delete(params)
    Database.new.delete_row(params)
  end

  def update(params)
    delete(params)
    Database.new.update_row(params)
  end

  def self.find(params)
    Database.new.row(params)
  end

  def self.index
    Database.new.rows
  end
end
