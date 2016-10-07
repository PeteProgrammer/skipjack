module Skipjack
  class FSharpCompiler
    attr_reader :target
    attr_writer :references

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

    def references
      @references ||= []
    end

    def create_file_task *args
      dependencies = source_files
      file_task = Rake::FileTask::define_task *args do |t|
        if t.application.windows?
          compiler = "fsc"
        else
          compiler = "fsharpc"
        end

        opts = []
        opts << "--out:#{t.name}"
        opts << "--target:#{target.to_s}"
        references.each { |r| opts << "--reference:#{r}" }

        cmd = "#{compiler} #{opts.join(" ")} #{source_files.join(" ")}"
        raise "Error executing command" unless Kernel.system cmd
      end
      file_task.enhance dependencies
    end

    def create_task
      create_file_task *@args
    end
  end
end

def fsc *args, &block
  c = Skipjack::FSharpCompiler.new *args, &block
  c.create_task
end
