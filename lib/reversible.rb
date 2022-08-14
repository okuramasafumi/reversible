# frozen_string_literal: true

require_relative 'reversible/version'

# Reversible module provides reversible method definition, inspired by ActiveRecord Migration
module Reversible
  class Error < StandardError; end

  # @api private
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Used with `up` call in reversible block
  class Up
    # @param object [Object] a base object that every block should be evaluated on
    def initialize(object)
      @object = object
    end

    # `up` block in reversible block
    def up(&block)
      @object.instance_exec(&block)
    end

    # `down` block is noop in reversible block
    def down(&block); end
  end

  # Used with `down` call in reversible block
  class Down
    # @param object [Object] a base object that every block should be evaluated on
    def initialize(object)
      @object = object
    end

    # `up` block is noop in reversible block
    def up(&block); end

    # `down` block in reversible block
    def down(&block)
      @object.instance_exec(&block)
    end
  end

  # @api private
  # A class that looks like a Proc but actually not, for evaluating given block in base object
  class MethodBlock
    def initialize(object, &block)
      @object = object
      @block = block
    end

    def call
      @object.instance_exec(&@block)
    end
  end

  # DSL
  module ClassMethods
    # Main method, defines two methods, `up` and `down` by default
    #
    # @oaram method_names [Array<Symbol, String>] an array of method names to be defined
    # @param &block [Proc] main code called with `up` and `down` methods on base object,
    #   in which `up` and `down` block can be used
    # @yield [dir] Gives direction to the block, `up` or `down`
    # @yield [dir, block] Gives direction to the block, `up` or `down`, and a block to be evaluated
    # @return [void]
    def reversible(*method_names, &block) # rubocop:disable Metrics/MethodLength
      define_method(method_names.shift || :up) do |*args, **kwargs, &blk|
        if blk
          instance_exec(Up.new(self), MethodBlock.new(self, &blk), *args, **kwargs, &block)
        else
          instance_exec(Up.new(self), *args, **kwargs, &block)
        end
      end
      define_method(method_names.shift || :down) do |*args, **kwargs, &blk|
        if blk
          instance_exec(Down.new(self), MethodBlock.new(self, &blk), *args, **kwargs, &block)
        else
          instance_exec(Down.new(self), *args, **kwargs, &block)
        end
      end
    end
  end
end
