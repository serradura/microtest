# frozen_string_literal: true

module RandomizedTests
  require 'forwardable'

  class Tracker
    include Singleton

    class << self
      extend Forwardable
      def_delegators :instance, :register, :data
    end

    def initialize
      @data = []
    end

    def register(klass, values)
      @data << [klass, values]
    end

    def data
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
      Tracker.register(self.class, @values)
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

  def self.assert_execution_order_with(test)
    expected_tracker_data = [
      [B, ['c', 'a', 'b', 'd']],
      [A, ['c', 'd', 'b', 'a']],
      [C, ['a', 'd', 'c', 'b']]
    ]

    test.new.assert(
      Tracker.data == expected_tracker_data,
      [
       'Tracked data of randomized execution',
       "must be eq #{expected_tracker_data}",
       "but it was #{Tracker.data}"
      ].join("\n")
    )
  end
end
