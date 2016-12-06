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
    @db.execute 'create table if not exists Posts
    (
	        id	INTEGER PRIMARY KEY AUTOINCREMENT,
	        create_date	DATE,
	        content	TEXT
    )'
end

get '/' do
    #choose list posts from DateBase
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

  #save data ib database
  @db.execute 'insert into Posts (content, create_date) values (?, datetime())', [content]

  erb "You typed: #{content}"
end