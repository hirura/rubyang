# coding: utf-8
# vim: et ts=2 sw=2

require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/respond_with'
require 'rubyang'

module Rubyang
  module RestAPI
    class App < Sinatra::Base
      set :environment, :development
      set :bind, '0.0.0.0'

      configure :development do
        register Sinatra::Reloader
      end

      register Sinatra::RespondWith


      target_yang = File.expand_path( File.dirname( __FILE__ ) ) + '/target.yang'
      model = Rubyang::Model::Parser.parse( File.open( target_yang, 'r' ).read )
      db = Rubyang::Database.new
      db.load_model model
      db.configure.edit('container1').edit('container2').edit('leaf1').set('value')


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

      run! if app_file == $0
    end
  end
end
