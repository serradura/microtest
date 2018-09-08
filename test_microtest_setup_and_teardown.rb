# frozen_string_literal: true

class TestMicrotestSetupAndTeardown < Microtest::Test
  def setup_all
    @increment = -> { counter = 0 and -> { counter += 1 } }.call
  end

  def setup(test_method)
    @last_setup_test_method = test_method
    @current_test_method_is_test_a = test_method == :test_a
  end

  def teardown(test_method)
    assert @last_setup_test_method == test_method
  end

  def teardown_all
    assert @increment.call == 1
  end

  def test_a
    assert @current_test_method_is_test_a
  end

  def test_b
    refute @current_test_method_is_test_a
  end
end
