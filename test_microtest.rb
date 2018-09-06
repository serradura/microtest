# frozen_string_literal: true

class TestMicrotest < Microtest::Test
  @@counter = 0

  def setup
    @@counter += 1
  end

  def teardown
    @@counter -= 1
  end

  def test_classic_assertion
    assert 1 == @@counter
  end

  test "assert" do
    assert 1 == @@counter, "assertion result must be true"
  end

  test "refute" do
    refute 1 != @@counter, "assertion result must be false"
  end
end
