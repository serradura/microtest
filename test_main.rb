# frozen_string_literal: true

ENV['SEED'] ||= '30407'

require_relative 'microtest'

%w[randomized microtest microtest_setup_and_teardown]
  .each { |file| require_relative "test_#{file}" }

Microtest.report do |runner|
  result = runner.call seed: ENV['SEED']

  expected_randomized_tests = [
    [TestRandomized::B, ['a', 'c', 'd', 'b']],
    [TestRandomized::A, ['a', 'b', 'd', 'c']],
    [TestRandomized::C, ['c', 'b', 'a', 'd']]
  ]

  Microtest::Test.new.assert(
    $__randomized_tests__ == expected_randomized_tests,
    [
     "Randomized result for Ruby 2.5.1",
     "must be #{expected_randomized_tests}",
     "but it was #{$__randomized_tests__}"
    ].join("\n")
  )

  result
end
