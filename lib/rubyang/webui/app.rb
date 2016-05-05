# coding: utf-8

require 'bundler/setup'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/content_for'

require_relative '../../rubyang'
require_relative 'make_json_schema'

module Rubyang
	module WebUI
		class App < Sinatra::Base
			set :environment, :development
			set :bind, '0.0.0.0'

			helpers Sinatra::ContentFor

			configure :development do
				register Sinatra::Reloader
			end


			target_yang = File.expand_path( File.dirname( __FILE__ ) ) + '/target.yang'
			model = Rubyang::Model::Parser.parse( File.open( target_yang, 'r' ).read )
			db = Rubyang::Database.new
			db.load_model model


			get '/' do
				locals = Hash.new
				erb :index, locals: locals
			end

			get '/api/reload_model' do
				target_yang = File.expand_path( File.dirname( __FILE__ ) ) + '/target.yang'
				model = Rubyang::Model::Parser.parse( File.open( target_yang, 'r' ).read )
				db = Rubyang::Database.new
				db.load_model @model
				'{}'
			end

			get '/api/schema' do
				schema_tree = db.configure.schema
				data = make_json_schema( schema_tree )
				puts data
				sleep 0
				data
			end

			get '/api/data' do
				config = db.configure
				data = config.to_json( pretty: true )
				puts data
				sleep 0
				data
			end

			post '/api/data' do
				request.body.rewind
				data = request.body.read
				puts data
				db.configure.load_override_json( data )
				sleep 1
				'{}'
			end

			run! if app_file == $0
		end
	end
end


