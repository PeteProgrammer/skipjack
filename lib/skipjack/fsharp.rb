module Skipjack
  class FSharpCompiler
    def initialize *args
      @args = *args
    end

    def create_task
      Rake::Task::define_task *@args do |t|
        if t.application.windows?
          cmd = "fsc"
        else
          cmd = "fsharpc"
        end
        raise "Error executing command" unless Kernel.system "#{cmd} "
      end
    end
  end
end

def fsc *args, &block
  c = Skipjack::FSharpCompiler.new *args
  c.create_task
end
