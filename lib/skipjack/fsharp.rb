def fsc *args, &block
  Rake::Task::define_task *args do |t|
    if t.application.windows?
      cmd = "fsc x y z"
    else
      cmd = "fsharpc x y z"
    end
    raise "Error executing command" unless Kernel.system "#{cmd} "
  end
end
