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

  def expect_no_system_call
    expect(Kernel).to_not receive(:system)
  end
end
