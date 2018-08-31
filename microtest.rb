# frozen_string_literal: true

require 'set'
require 'singleton'
require 'forwardable'

module Microtest
  VERSION = '0.1.0'

  class Runner
    include Singleton

    class << self
      extend Forwardable
      def_delegators :instance, :register, :call
    end

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
          invoke(test_case, :setup) { test_method }
          invoke(test_case, test_method)
          invoke(test_case, :teardown) { test_method }
        end

        invoke(test_case, :teardown_all)
      end
    end

    private

    def invoke(test_case, step)
      return unless test_case.respond_to?(step)
      step_arg = yield if block_given?
      test_case.public_send(*[step, step_arg].compact)
    rescue ArgumentError
      test_case.public_send(step)
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
      Runner.register(test_case)
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
    Runner.call

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
