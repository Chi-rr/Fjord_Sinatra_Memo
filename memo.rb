# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "csv"
require_relative "app"

class Memo
  def create(params)
    @id = create_id
    add_row(params)
  end

  def delete(params)
    @id = params[:id]
    memos = CSV.read("memos.csv")
    remove_memo = memos.assoc("#{@id}")
    memos.delete(remove_memo)
    # memos = remove_memoが取り除かれた配列
    CSV.open("memos.csv", "w",  headers: true) do |csv|
      memos.each do |memo|
        csv << memo
      end
    end
  end

  def update(params)
    delete(params)
    add_row(params)
  end

  def create_id
    @table = CSV.table("memos.csv")
    @table[:id].count > 0 ? @table[:id].max.next : 1
  end

  def add_row(params)
    CSV.open("memos.csv", "a",  headers: true) do |csv|
      csv << create_row(params)
    end
  end

  def create_row(params)
    CSV::Row.new(
      ["id", "memo_name", "memo_content"],
      ["#{@id}", "#{params[:memo_name]}", "#{params[:memo_content]}"]
    )
  end

  def find_memo(params)
    CSV.read("memos.csv").assoc("#{params[:id]}")
  end

  def index_memos
    @table = CSV.table("memos.csv")
    [@table[:id], @table[:memo_name]].transpose
  end
end
