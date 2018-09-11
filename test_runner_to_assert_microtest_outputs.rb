# frozen_string_literal: true

require_relative 'microtest'

class FakeOutput
  def initialize
    @history = []
  end

  def history
    @history.dup
  end

  def puts(message)
    @history << message and nil
  end
end

def output_to(test, &block)
  out = FakeOutput.new

  Microtest.report(out: out) { test.instance_eval(&block) }

  out.history.join(' ')
end

Microtest.report(out: Kernel) do |_runner|
  test = Microtest::Test.new

  # assert

  assert_successful_output = output_to(test) { assert(true) }

  test.assert assert_successful_output.include?('Tests passed!')

  assert_failure_output = output_to(test) { assert(false) }

  test.assert assert_failure_output.include?('false is not truthy')

  assert_failure_output_with_custom_msg = output_to(test) do
    assert(false, 'custom message')
  end

  test.assert assert_failure_output_with_custom_msg.include?('custom message')

  # refute

  refute_successful_output = output_to(test) { refute(false) }

  test.assert refute_successful_output.include?('Tests passed!')

  refute_failure_output = output_to(test) { refute(true) }

  test.assert refute_failure_output.include?('true is neither nil or false.')

  refute_failure_output_with_custom_msg = output_to(test) do
    refute(true, 'custom message')
  end

  test.assert refute_failure_output_with_custom_msg.include?('custom message')
end
