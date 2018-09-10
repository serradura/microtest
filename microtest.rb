# frozen_string_literal: true

require 'set'
require 'singleton'

module Microtest
  VERSION = '0.4.0'

  BuildRandom = -> (seed, randomized) do
    Random.new Integer(seed ? seed : rand(1000..99999)) if seed || randomized
  end

  RandomBuilder = -> (randomized) { BuildRandom.call(ENV['SEED'], randomized) }

  class Runner
    include Singleton

    def initialize
      @test_cases = Set.new
    end

    def register(test_case)
      @test_cases.add(test_case) and true
    end

    def call(random:)
      iterate_each_test_after_try_to_apply(random) do |test, test_methods|
        test.call(:setup_all)

        test_methods.each do |test_method|
          test.call(:setup, test_method)
          test.call(test_method)
          test.call(:teardown, test_method)
        end

        test.call(:teardown_all)
      end
    end

    private

    def iterate_each_test_after_try_to_apply(random)
      list(@test_cases, random).each do |test_case|
        yield method(:test_caller).curry[test_case.new],
              list(test_case.public_instance_methods.grep(/\Atest_/), random)
      end
    end

    def test_caller(test_case, method_to_call, method_arg = nil)
      return unless test_case.respond_to?(method_to_call)
      method = test_case.method(method_to_call)
      method.arity == 0 ? method.call : method.call(method_arg)
    end

    def list(relation, random)
      random ? relation.to_a.shuffle(random: random) : relation
    end
  end

  class Test
    FAILURE_MESSAGE = 'Failed test'

    def self.inherited(test_case)
      Runner.instance.register(test_case)
    end

    def self.test(name, &block)
      method = "test_#{name.gsub(/\s+/,'_')}"
      raise "#{method} is already defined in #{self}" if method_defined?(method)
      define_method(method, &block)
    end

    def assert(test, msg = FAILURE_MESSAGE)
      stop!(caller, msg) unless test
    end

    def refute(test, msg = FAILURE_MESSAGE)
      stop!(caller, msg) if test
    end

    private

    def stop!(kaller, msg)
      caller_location = kaller[0].split('/').last
      raise RuntimeError, msg, [caller_location]
    end
  end

  def self.report(randomized = nil)
    yield result = RandomBuilder.call(randomized)

    puts "\n\e[#{32}m\u{1f60e} Tests passed!\e[0m\n\n"
  rescue => e
    content = ["\u{1f4a9} <#{e.class}> #{e.message}\n", e.backtrace.join("\n")]

    puts ["\e[#{31}m", content, "\e[0m"].flatten.join("\n")
  ensure
    puts "Randomized with seed: #{result.seed}\n\n" if result.is_a?(Random)
  end

  def self.call(randomized: false)
    report(randomized) { |random| Runner.instance.call(random: random) }
  end
end
