# frozen_string_literal: true

module RandomizedTests
  require 'forwardable'

  class ExecutionOrderTracker
    include Singleton

    class << self
      extend Forwardable
      def_delegators :instance, :register, :registered
    end

    def initialize
      @data = []
    end

    def register(test, values)
      @data << [test.class, values]
    end

    def registered
      @data.dup
    end
  end

  def self.execution_records
    @memo ||= []
  end

  class A < Microtest::Test
    def setup_all
      @values = []
    end

    def teardown_all
      ExecutionOrderTracker.register(self, @values)
    end

    test('a') { @values << 'a' }
    test('b') { @values << 'b' }
    test('c') { @values << 'c' }
    test('d') { @values << 'd' }
  end

  class B < A
  end

  class C < A
  end

  def self.assert_execution_order_with(test, expected_order:)
    registered_execution_order = ExecutionOrderTracker.registered

    test.new.assert(
      registered_execution_order == expected_order,
      ['The randomized execution order',
       "must be eq #{expected_order}",
       "but it was #{registered_execution_order}"].join("\n")
    )
  end
end
