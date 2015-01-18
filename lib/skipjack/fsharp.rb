module Skipjack
  class FSharpCompiler
    attr_accessor :target

    def initialize *args
      @args = *args
      yield self if block_given?
    end

    def create_task
      Rake::Task::define_task *@args do |t|
        if t.application.windows?
          compiler = "fsc"
        else
          compiler = "fsharpc"
        end

        cmd = "#{compiler} --target:#{target.to_s}"
        raise "Error executing command" unless Kernel.system cmd
      end
    end
  end
end

def fsc *args, &block
  c = Skipjack::FSharpCompiler.new *args, &block
  c.create_task
end
