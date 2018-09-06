# frozen_string_literal: true

require_relative "microtest"

Dir['test_*.rb']
  .reject { |file| file =~ /#{__FILE__.split('/').last}/ }
  .each { |file| require_relative file }

Microtest.call
