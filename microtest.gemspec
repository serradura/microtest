require_relative 'microtest'

Gem::Specification.new do |s|
  s.name         = 'u-test'
  s.summary      = 'A unit testing microframework'
  s.description  = 'A xUnit family unit testing microframework for Ruby.'
  s.version      = Microtest::VERSION
  s.licenses     = ['MIT']
  s.platform     = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.2'

  s.files        = ['microtest.rb', 'u-test.rb']
  s.require_path = '.'

  s.author    = 'Rodrigo Serradura'
  s.email     = 'rodrigo.serradura@gmail.com'
  s.homepage  = 'https://gist.github.com/serradura/d26f7f322977e35dd508c8c13a9179b1'

  s.test_file = 'test_runners.rb'
end
