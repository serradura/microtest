# frozen_string_literal: true

require_relative 'microtest'

class TestNumberConstants < Microtest::Test
  def setup_all
    @number = self.class.const_get(:NUMBER)
  end

  def call_number_assertion
    assert @number.is_a?(Numeric)
  end
end

class TestNumberOne < TestNumberConstants
  NUMBER = 1
  alias_method :test_number, :call_number_assertion
end

class TestFixnumNumber < TestNumberConstants
  NUMBER = 1
  alias_method :test_number, :call_number_assertion
end

class TestFloatNumber < TestNumberConstants
  NUMBER = 1.0
  alias_method :test_number, :call_number_assertion
end

class TestBigDecimalNumber < TestNumberConstants
  require 'bigdecimal'
  NUMBER = BigDecimal('1.0')
  alias_method :test_number, :call_number_assertion
end

Microtest.call
