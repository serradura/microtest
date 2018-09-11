# frozen_string_literal: true

class TestMicrotest < Microtest::Test
  def setup
    @counter ||= 0 and @counter += 1
  end

  def teardown
    @counter -= 1
  end

  def test_truthy
    assert 1
    assert ''
    assert true
  end

  def test_falsey
    refute false
    refute nil
  end

  def test_method_assertion
    assert 1 == @counter
  end

  test 'assert' do
    assert 1 == @counter, 'assertion result must be true'
  end

  test 'refute' do
    refute 1 != @counter, 'assertion result must be false'
  end
end
