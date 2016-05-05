# coding: utf-8

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader'
require 'json'

require_relative '../../rubyang'
db = Rubyang::Database.new
yang_str = <<-EOB
	module module1 {
		namespace "http://module1/";
		prefix module1;
		container container1 {
			container container2 {
				leaf leaf1 { type string; }
			}
		}
	}
EOB
db.load_model Rubyang::Model::Parser.parse( yang_str )
config = db.configure
config.edit( 'container1' ).edit( 'container2' ).edit( 'leaf1' ).set( 'aaa' )


get '/' do
	respond_to do |f|
		f.on( 'application/xml' ){
			config = db.configure
			config.to_xml( pretty: true )
		}
	end
end

get %r{/api(?:/(.+)[/]?)} do
	respond_to do |f|
		f.on( 'application/xml' ){
			#{ params: ' '+params[:captures][0] }.to_json
			config = db.configure
			paths = params[:captures][0].split( '/' )
			element = paths.inject( config ){ |parent, child| parent.edit( child ) }
			element.to_xml( pretty: true )
		}
	end
end

post %r{/api(?:/(.+)[/]?)} do
	body = request.body.read
	respond_to do |f|
		f.on( 'application/xml' ){
			config = db.configure
			paths = params[:captures][0].split( '/' )
			element = paths.inject( config ){ |parent, child| parent.edit( child ) }
		}
	end
end

get %r{/api[/]?} do
	respond_to do |f|
		f.on( 'application/xml' ){ db.configure.to_xml( pretty: true ) }
	end
end
