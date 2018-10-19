# frozen_string_literal: true

ENV['SEED'] ||= '30407'

require_relative 'microtest'

require_relative 'test_randomized_tests'

Microtest.report(out: Kernel) do |runner|
  runner.call

  RandomizedTests.assert_execution_order_with Microtest::Test, expected_order: [
    [RandomizedTests::B, ['c', 'a', 'b', 'd']],
    [RandomizedTests::C, ['d', 'c', 'b', 'a']],
    [RandomizedTests::A, ['b', 'd', 'a', 'c']]]
end
