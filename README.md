# Microtest

A xUnit family unit testing microframework for Ruby.

## Prerequisites

> Ruby >= 2.2.2

## Installation

Add this line to your application's Gemfile:
```
gem 'u-test'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install u-test
```

## How to use

### 1) Create your awesome project
```ruby
# number.rb
module Number
  ALL = [
    ONE = 1
    TWO = 2
  ]
end
```

### 2) Create your test suite
```ruby
# test_number_one.rb
class TestNumberOne < Microtest::Test
  def test_with_assert_method
    assert Number::ONE == Number::ONE
  end
end

# test_number_two.rb
class TestNumberTwo < Microtest::Test
  def test_with_refute_method
    refute Number::TWO == Number::ONE
  end
end

# test_all_numbers.rb
class TestAllNumbers < Microtest::Test
  def test_all_numbers_constant
    assert Number::ALL == [1, 2]
  end
end
```

### 3) Create the test runner
```ruby
# test_runner.rb
require_relative 'number'

# If you decided to embed the microtest code with your project (case of usage: a gist).
require_relative 'microtest'
# Or install and use it via rubygems (gem install 'u-test') and `require 'microtest'`.

Dir['test_number*.rb']
  .reject { |file| file.include?(__FILE__.split('/').last) }
  .each { |file| require_relative file }

Microtest.call
```

### 4) Run your tests
```sh
ruby test_runner.rb
```

## Features

### Hooks
```ruby
class TestSomething < Microtest::Test
  def setup_all
    # Runs once and before all tests.
  end

  def setup
    # Runs before each test.
    #   NOTE: you can receive the method in execution as the hook argument.
    #   def setup(test_method)
    #   end
  end

  def teardown
    # Runs after each test.
    #   NOTE: you can receive the method in execution as the hook argument.
    #   def teardown(test_method)
    #   end
  end

  def teardown_all
    # Runs once and after all tests.
  end
end
```

### Declarative approach
```ruby
class TestSomething < Microtest::Test
  test('a') { assert 1 == 1}

  test 'b' do
    assert 1 == 1
  end

  # The above examples are the same thing as:
  # def test_a
  #   assert 1 == 1
  # end
end
```

### Randomized execution

Use a seed value if do you want a random execution.
```sh
SEED=1234 ruby test_runner.rb
```

Or enable it via `Microtest.call`. e.g:
```ruby
Microtest.call randomized: true
```

## Running the tests

```sh
  rake test
  # or
  ruby test_runners.rb
```
