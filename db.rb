# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "pg"

class Database
  def initialize
    @conn = PG.connect(dbname: "sinatra_memo")
  end

  def create_row(memo_name, memo_content)
    @id = select_id
    @conn.exec_params(
      "INSERT INTO memo VALUES ($1, $2, $3)",
      [@id, memo_name, memo_content]
    )
  end

  def delete_row(id)
    @conn.exec_params("DELETE FROM memo WHERE id= $1", [id])
  end

  def update_row(id, memo_name, memo_content)
    @conn.exec_params(
      "INSERT INTO memo VALUES ($1, $2, $3)",
      [id, memo_name, memo_content]
    )
  end

  def row(id)
    @conn.exec_params("SELECT * FROM memo WHERE id= $1", [id])
  end

  def rows
    @conn.exec("SELECT * FROM memo")
  end

  private
    def select_id
      result = @conn.exec("SELECT id FROM memo")
      ids = result.column_values(0).map(&:to_i)
      ids.count > 0 ? ids.max.next : 1
    end
end
