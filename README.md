# Reversible

Provides reversible method definition, inspired by ActiveRecord Migration.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add reversible

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install reversible

## Usage

### Basic

```ruby
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
```

Now, class `Foo` has two methods: `up` and `down`. With `up` method, only `dir.up` block is executed and `dir.down` block is ignored. It works the same with `down`.

```ruby
foo = Foo.new(1)
foo.up
# Before action
# Up with id: 1
# After action
foo.down
# Before action
# Down with id: 1
# After action
```

### With arguments

We can call `up` method with any argument. It's passed to the second block parameter.

```ruby
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

bar = Bar.new(id: 1)
bar.update(id: 2)
# Before: {:id=>1}
# After: {:id=>2}
bar.undo_update
# Before: {:id=>2}
# After: {:id=>1}
```

### With block

We can even pass a block to `up` and `down` methods.

```ruby
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

baz = Baz.new
baz.up do
  self.count += 1
  puts self.count
end
# up!
# 1
baz.down do
  self.count -= 1
  puts self.count
end
# down!
# 0
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okuramasafumi/reversible. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/okuramasafumi/reversible/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Reversible project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/okuramasafumi/reversible/blob/master/CODE_OF_CONDUCT.md).
