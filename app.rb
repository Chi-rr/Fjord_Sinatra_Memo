# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "memo"

# メモの一覧表示
get "/" do
  @memos_link = Memo.index
  erb :index
end

# メモの新規投稿
post "/" do
  Memo.new.create(params[:memo_name], params[:memo_content])
  redirect to("/")
end

# メモ新規作成フォーム
get "/new" do
  erb :new
end

# パスの受け取り/メモの詳細表示
get "/:id" do
  @memo = Memo.find(params[:id])
  @content = @memo[2].gsub(/\r\n/, "<br>")
  erb :show
end

# メモの編集フォーム
get "/:id/edit" do
  @memo = Memo.find(params[:id])
  erb :edit
end

# メモの修正投稿
patch "/:id" do
  Memo.new.update(params)
  redirect to("/")
end

# メモの削除
delete "/:id" do
  Memo.new.delete(params[:id])
  redirect to("/")
end
