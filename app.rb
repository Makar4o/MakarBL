#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'

def init_db
    @db = SQLite3::Database.new 'MakarBL.db'
    @db.results_as_hash = true
end

before do
  init_db
end

configure do
    #intialization DataBase
    init_db
    # create table if not exist table
    @db.execute 'CREATE TABLE IF NOT EXISTS Posts
    (
	        id	INTEGER PRIMARY KEY AUTOINCREMENT,
	        create_date	DATE,
	        content	TEXT
    )'

    @db.execute 'CREATE TABLE IF NOT EXISTS Comments
    (
	        id	INTEGER PRIMARY KEY AUTOINCREMENT,
	        create_date	DATE,
	        content	TEXT,
          id integer
    )'

end

get '/' do
    # choose list posts from DateBase

    @results = @db.execute 'select * from Posts order by id desc'

  erb :index
end

get '/new' do

  erb :new
end

post '/new' do
  content = params[:content]

  if content.length <= 0
    @error = 'Type post text'
    return erb :new
  end

  # save data ib database
  @db.execute 'insert into Posts (content, create_date) values (?, datetime())', [content]

  # redirect on the main page (Last posts)
  redirect to '/'
end

get '/post/:id' do

  post_id = params[:id]

  results = @db.execute 'select * from Posts where id = ?', [post_id]
  @row = results[0]

  erb :post_commit
end

post '/post_commit/:id' do
  post_id = params[:id]
  content = params[:content]

  erb "You typed comment #{content} for post #{post_id}"
end