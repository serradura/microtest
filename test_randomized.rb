# frozen_string_literal: true

$__randomized_tests__ = []

module TestRandomized
  class A < Microtest::Test
    def setup_all
      @values = []
    end

    def teardown_all
      $__randomized_tests__ << [self.class, @values]
    end

    test('a') { @values << 'a' }
    test('b') { @values << 'b' }
    test('c') { @values << 'c' }
    test('d') { @values << 'd' }
  end

  class B < Microtest::Test
    def setup_all
      @values = []
    end

    def teardown_all
      $__randomized_tests__ << [self.class, @values]
    end

    test('a') { @values << 'a' }
    test('b') { @values << 'b' }
    test('c') { @values << 'c' }
    test('d') { @values << 'd' }
  end

  class C < Microtest::Test
    def setup_all
      @values = []
    end

    def teardown_all
      $__randomized_tests__ << [self.class, @values]
    end

    test('a') { @values << 'a' }
    test('b') { @values << 'b' }
    test('c') { @values << 'c' }
    test('d') { @values << 'd' }
  end
end
