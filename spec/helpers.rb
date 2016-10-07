module Helpers
  def invoke_fsc_task &block
    task = fsc :build, &block
    task.invoke
  end

  def expect_system_call 
    allow(Kernel).to receive(:system) do |args|
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
    attr_accessor :executable, :target, :out
    attr_accessor :resident
    attr_writer :source_files
    attr_writer :references

    def initialize
      yield self if block_given?
    end

    def source_files
      @source_files ||= []
    end

    def references
      @reference ||= []
    end
  end

  def parse_cmd cmd
    args = cmd.split
    executable = args[0]
    args.shift

    CompilerOptions.new do |c|
      c.resident = false
      c.executable = executable
      /--target:(\w*)/.match(cmd) do |m|
        c.target = m[1]
      end

      %r{--out:([\w\./]*)}.match(cmd) do |m|
        c.out = m[1]
      end

      %r{--resident}.match(cmd) do
        c.resident = true
      end

      cmd.scan(/--reference:([^ ]*)/) do |m|
        c.references << m[0]
      end

      c.source_files = args.select { |f| f[0] != '-' }
    end
  end
end
