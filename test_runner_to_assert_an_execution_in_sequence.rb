# frozen_string_literal: true

ENV['SEED'] = nil

require_relative 'microtest'

require_relative 'test_randomized_tests'

Microtest.report(out: Kernel) do |runner|
  runner.call

  RandomizedTests.assert_execution_order_with Microtest::Test, expected_order: [
    [RandomizedTests::A, ['a', 'b', 'c', 'd']],
    [RandomizedTests::B, ['a', 'b', 'c', 'd']],
    [RandomizedTests::C, ['a', 'b', 'c', 'd']]
  ]
end
