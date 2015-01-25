module Skipjack
  class FSharpCompiler
    attr_reader :target
    attr_accessor :output_folder, :output_file

    def initialize *args
      @args = *args
      yield self if block_given?
    end

    def target=(val)
      raise "Invalid target: #{val}" unless %w(exe winexe library module).include? val.to_s
      @target = val
    end

    def source_files=(val)
      @source_files = val
    end

    def source_files
      @source_files ||= []
    end

    def create_task
      Rake::Task::define_task *@args do |t|
        if t.application.windows?
          compiler = "fsc"
        else
          compiler = "fsharpc"
        end

        out = output_folder ? "--out:#{output_folder}/#{output_file}" : "--out:#{output_file}"
        src = source_files.join(" ")
        cmd = "#{compiler} #{out} --target:#{target.to_s} #{src}"
        raise "Error executing command" unless Kernel.system cmd
      end
    end
  end
end

def fsc *args, &block
  c = Skipjack::FSharpCompiler.new *args, &block
  c.create_task
end
