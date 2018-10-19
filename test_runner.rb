# frozen_string_literal: true

require_relative 'microtest'

%w[test_microtest test_microtest_setup_and_teardown]
  .each { |file| require_relative file }

Microtest.call(exit_when_finish: true) # or Microtest.call randomized: false
