# frozen_string_literal: true

require 'test_helper'

class TestReversible < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Reversible::VERSION
  end

  class Foo
    include Reversible

    def initialize(id)
      @id = id
    end

    reversible do |dir|
      puts 'Before action'
      dir.up { puts "Up with id: #{@id}" }
      dir.down { puts "Down with id: #{@id}" }
      puts 'After action'
    end
  end

  def test_it_works_with_instance_variable
    assert_output("Before action\nUp with id: 1\nAfter action\nBefore action\nDown with id: 1\nAfter action\n") do
      foo = Foo.new(1)
      foo.up
      foo.down
    end
  end

  class Bar
    include Reversible

    def initialize(data)
      @data = data
    end

    reversible :update, :undo_update do |dir, new_data|
      puts "Before: #{@data}"
      dir.up do
        @old_data = @data.dup
        @data.update(new_data)
      end
      dir.down { @data = @old_data.dup }
      puts "After: #{@data}"
    end
  end

  def test_it_works_with_argument
    assert_output("Before: {:id=>1}\nAfter: {:id=>2}\nBefore: {:id=>2}\nAfter: {:id=>1}\n") do
      bar = Bar.new(id: 1)
      bar.update(id: 2)
      bar.undo_update
    end
  end

  class Baz
    include Reversible

    attr_accessor :count

    def initialize
      @count = 0
    end

    reversible do |dir, block|
      dir.up { puts 'up!' }
      dir.down { puts 'down!' }
      block.call
    end
  end

  def test_it_works_with_block # rubocop:disable Metrics/MethodLength
    assert_output("up!\n1\ndown!\n0\n") do
      baz = Baz.new
      baz.up do
        self.count += 1
        puts self.count
      end
      baz.down do
        self.count -= 1
        puts self.count
      end
    end
  end
end
