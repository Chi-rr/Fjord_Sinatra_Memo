# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "pg"

class Database
  def initialize
    @conn = PG.connect(dbname: "sinatra_memo")
  end

  def create_row(params)
    @id = select_id
    @conn.exec(
      "INSERT INTO memo VALUES ($1, $2, $3)",
      [@id, "#{params[:memo_name]}", "#{params[:memo_content]}"]
    )
  end

  def delete_row(params)
    @conn.exec("DELETE FROM memo WHERE id= #{params[:id]}")
  end

  def update_row(params)
    @conn.exec(
      "INSERT INTO memo VALUES ($1, $2, $3)",
      ["#{params[:id]}", "#{params[:memo_name]}", "#{params[:memo_content]}"]
    )
  end

  def row(params)
    result = @conn.exec("SELECT * FROM memo WHERE id= #{params[:id]}")
    result.each do |tuple|
      @row = [tuple["id"], tuple["memo_name"], tuple["memo_content"]]
    end
    @row
  end

  def rows
    result = @conn.exec("SELECT * FROM memo")
    @rows = []
    result.each { |tuple| @rows << [tuple["id"], tuple["memo_name"]] }
    @rows
  end

  private
    def select_id
      result = @conn.exec("SELECT id FROM memo")
      ids = []
      result.each { |tuple| ids << tuple["id"] }
      ids.count > 0 ? ids.max.next : 1
    end
end
