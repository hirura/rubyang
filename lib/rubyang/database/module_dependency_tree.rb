# coding: utf-8
# vim: et ts=2 sw=2

module Rubyang
  class Database
    class ModuleDependencyTree
      class Node
        def initialize yang
          @yang = yang
          @children = []
        end

        def yang
          @yang
        end

        def add_child node
          @children.push node
        end

        def each_child
          @children.each{ |c| yield c }
        end
      end

      class Root < Node
        def initialize
          @children = []
        end

        def register yang
          node = Node.new yang
          each_child{ |c|
            if c.yang.substmts(['include', 'import']).any?{ |s| s.arg == yang.arg }
              c.add_child node
            end
            if yang.substmts(['include', 'import']).any?{ |s| s.arg == c.yang.arg }
              node.add_child c
            end
          }
          add_child node
        end

        def breadth_scan
          queue = Array.new
          list = Array.new
          each_child{ |c| queue.push c }
          while child = queue.shift
            list.push child.yang
            child.each_child{ |c| queue.push c }
          end
          list
        end
      end

      def initialize
        @root = Root.new
      end

      def register yang
        @root.register yang
      end

      def list_loadable
        @root.breadth_scan.reverse.uniq
      end
    end
  end
end
