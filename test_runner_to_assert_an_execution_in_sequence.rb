# frozen_string_literal: true

ENV['SEED'] = nil

require_relative 'microtest'

require_relative 'test_randomized_tests'

Microtest.report(out: Kernel) do |runner|
  runner.call

  RandomizedTests.assert_execution_order_with Microtest::Test, expected_order: [
    [RandomizedTests::A, ['d', 'a', 'b', 'c']],
    [RandomizedTests::B, ['d', 'a', 'b', 'c']],
    [RandomizedTests::C, ['d', 'a', 'b', 'c']]
  ]
end
