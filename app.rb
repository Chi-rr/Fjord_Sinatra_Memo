# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "csv"
require_relative "memo"

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
