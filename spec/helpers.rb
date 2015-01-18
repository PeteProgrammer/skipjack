module Helpers
  def invoke_fsc_task &block
    task = fsc :build, &block
    task.invoke
  end

  def expect_system_call 
    expect(Kernel).to receive(:system) do |args|
      yield args
    end
  end

  def expect_compiler_call
    expect_system_call do |cmd|
      options = parse_cmd cmd
      yield options
    end
  end

  def expect_no_system_call
    expect(Kernel).to_not receive(:system)
  end

  class CompilerOptions
    attr_accessor :executable

    def initialize
      yield self if block_given?
    end
  end

  def parse_cmd cmd
    args = cmd.split
    executable = args[0]
    args.shift

    CompilerOptions.new do |c|
      c.executable = executable
    end
  end
end
