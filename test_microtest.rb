# frozen_string_literal: true

require_relative 'microtest'

class TestMicrotest < Microtest::Test
  def setup_all
    @final_assertion = -> (test) { test.assert true }
  end

  def setup(test_method)
    @a = test_method == :test_a
    @last_setup_test_method = test_method
  end

  def teardown(test_method)
    assert @last_setup_test_method == test_method
  end

  def teardown_all
    @final_assertion.call(self)
  end

  def test_a
    assert @a
  end

  def test_b
    refute @a
  end
end

Microtest.call
