# coding: utf-8
# vim: et ts=2 sw=2

require 'open3'
require 'drb/drb'
require 'rubyang'

module Rubyang
  class Database
    class ComponentManager
      class Component
        attr_reader :name, :hook, :path, :sock, :thread, :instance

        def initialize name, hook, path
          @name = name
          @hook = hook
          @path = path
          @sock = "/tmp/rubyang/component/#{@name}.sock"
        end

        def start
          begin
            @thread = Thread.new( @path ) do |path|
              stdout, stderr, status = Open3.capture3( "#{RUBY_ENGINE} #{path}" )
            end
            10.times{ |i|
              break if File.socket? @sock
              sleep 1
              raise "Load failed: #{@name} : #{@path}" if i == 9
            }
            @instance = DRbObject.new_with_uri( "drbunix:#{@sock}" )
          rescue => e
            puts "Error: #{e}"
          end
        end

        def run
          begin
            @instance.run
          rescue => e
            puts "Error: #{e}"
          end
        end
      end

      def initialize
        @components = Array.new
      end

      def update components
        current_component_names = @components.map{ |c| c.name }
        new_component_names = components.map{ |c| c[0] }
        unloading_component_names = current_component_names - new_component_names
        loading_component_names = new_component_names - current_component_names
        puts "Load: #{loading_component_names}"
        puts "Unload: #{unloading_component_names}"
        unloading_component_names.each{ |n|
          component = @components.find{ |c| c.name == n }
          component.thread.kill
          @components.delete_if{ |c| c.name == n }
        }
        loading_component_names.each{ |n|
          name, hook, path = components.find{ |c| c[0] == n }
          component = Component.new name, hook, path
          component.start
          @components.push component
        }
      end

      def run hook
        @components.select{ |c| c.hook == hook }.each{ |c|
          c.run
        }
      end
    end
  end
end
