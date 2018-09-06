# frozen_string_literal: true

class TestMicrotestSetupAndTeardown < Microtest::Test
  def setup_all
    @increment = -> { counter = 0 and -> { counter += 1 } }.call
    @final_assertion = -> (test, increment, expected_increment_value:) do
      test.assert increment == expected_increment_value
    end
  end

  def setup(test_method)
    @last_setup_test_method = test_method
    @test_method_name_is_test_a = test_method == :test_a
  end

  def teardown(test_method)
    assert @last_setup_test_method == test_method
  end

  def teardown_all
    @final_assertion.call(self, @increment.call, expected_increment_value: 1)
  end

  def test_a
    assert @test_method_name_is_test_a
  end

  def test_b
    refute @test_method_name_is_test_a
  end
end
