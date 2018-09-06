# frozen_string_literal: true

require 'set'
require 'singleton'

module Microtest
  VERSION = '0.2.0'

  class Runner
    include Singleton

    def initialize
      @test_cases = Set.new
    end

    def register(test_case)
      @test_cases.add(test_case) and true
    end

    def call
      call_each do |test_case, test_methods|
        invoke(test_case, :setup_all)

        test_methods.each do |test_method|
          invoke(test_case, :setup, test_method)
          invoke(test_case, test_method)
          invoke(test_case, :teardown, test_method)
        end

        invoke(test_case, :teardown_all)
      end
    end

    private

    def invoke(test_case, step_method, test_method = nil)
      return unless test_case.respond_to?(step_method)
      test_case.public_send(*[step_method, test_method].compact)
    rescue ArgumentError
      test_case.public_send(step_method)
    end

    def call_each
      @test_cases.each do |klass|
        yield klass.new, klass.public_instance_methods.grep(/\Atest_/)
      end
    end
  end

  class Test
    FAILURE_MESSAGE = "Failed test"

    def self.inherited(test_case)
      Runner.instance.register(test_case)
    end

    def self.test(name, &block)
      test_method = "test_#{name.gsub(/\s+/,'_')}"

      raise "#{test_method} is already defined in #{self}" if method_defined?(test_method)

      define_method(test_method, &block)
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

  def self.call
    Runner.instance.call

    puts "\n\e[#{32}mTests passed! \u{1f60e}\e[0m\n\n"
  rescue => e
    puts <<~MSG
      \e[#{31}m
      <#{e.class}> #{e.message} \u{1f4a9}\n
      #{e.backtrace.join("\n")}
      \e[0m
    MSG
  end
end
