def fsc *args, &block
  Rake::Task::define_task *args do |t|
    if t.application.windows?
      cmd = "fsc"
    else
      cmd = "mono fsharpc"
    end
    raise "Error executing command" unless Kernel.system cmd
  end
end
