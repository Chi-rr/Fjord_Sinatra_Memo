# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "csv"

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

enable :method_override
# メモの一覧表示
get "/" do
  @memos_link = Memo.new.index_memos
  erb :index
end

# メモの新規投稿
post "/" do
  Memo.new.create(params)
  redirect to("/")
end

# メモ新規作成フォーム
get "/new" do
  erb :new
end

# パスの受け取り/メモの詳細表示
get "/:id" do
  @memo = Memo.new.find_memo(params)
  @content = @memo[2].gsub(/\r\n/, "<br>")
  erb :show
end

# メモの編集フォーム
get "/:id/edit" do
  @memo = Memo.new.find_memo(params)
  erb :edit
end

# メモの修正投稿
patch "/:id" do
  Memo.new.update(params)
  redirect to("/")
end

# メモの削除
delete "/:id" do
  Memo.new.delete(params)
  redirect to("/")
end
