# frozen_string_literal: true

ENV['SEED'] ||= '30407'

require_relative 'microtest'

require_relative 'test_randomized_tests'

Microtest.report do |runner|
  runner.call

  RandomizedTests.assert_execution_order_with Microtest::Test, expected_order: [
    [RandomizedTests::B, ['d', 'b', 'c', 'a']],
    [RandomizedTests::C, ['a', 'd', 'c', 'b']],
    [RandomizedTests::A, ['c', 'a', 'b', 'd']]
  ]
end
