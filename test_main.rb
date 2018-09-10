# frozen_string_literal: true

ENV['SEED'] ||= '30407'

require_relative 'microtest'

%w[randomized_tests microtest microtest_setup_and_teardown]
  .each { |file| require_relative "test_#{file}" }

Microtest.report do |random|
  Microtest::Runner.instance.call random: random

  RandomizedTests.assert_execution_order_with(Microtest::Test)
end
