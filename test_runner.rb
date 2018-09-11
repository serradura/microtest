# frozen_string_literal: true

class RunRubyProgram
  LINE_CHAR = '#'

  def self.line(command)
    (LINE_CHAR * command.size) + LINE_CHAR * 4
  end

  def self.cmd(file)
    yield "ruby #{file}.rb"
  end

  def self.render_cmd(file)
    cmd(file) do |command|
      puts line(command)
      puts "#{LINE_CHAR} #{command} #{LINE_CHAR}"
      puts line(command)

      yield(command) if block_given?
    end
  end

  def self.call(file)
    render_cmd(file) { |command| system(command) }
  end
end

require_relative 'microtest'

%w[test_microtest test_microtest_setup_and_teardown]
  .each { |file| require_relative file }

RunRubyProgram.render_cmd('test_runner') do
  Microtest.call # or Microtest.call randomized: false
end

RunRubyProgram.call('test_runner_to_assert_a_random_execution')

RunRubyProgram.call('test_runner_to_assert_an_execution_in_sequence')