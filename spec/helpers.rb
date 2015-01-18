module Helpers
  def invoke_fsc_task &block
    task = fsc :build, &block
    task.invoke
  end

  def expect_system_call 
    expect(Kernel).to receive(:system) do |args|
      result = yield args
      if result.nil? then
        true
      else
        result
      end
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
    attr_accessor :executable, :target

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
      /--target:(\w*)/.match(cmd) do |m|
        c.target = m[1]
      end
    end
  end
end
