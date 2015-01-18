describe 'fsharp' do
  before :each do |example|
    @app = Rake::Application.new
    Rake.application = @app

    # mock if we are running windows or not
    windows = example.metadata[:windows]
    windows = true if windows.nil? #default to true as this is a simpler case (no mono prefix)
    allow(@app).to receive("windows?").and_return windows
  end

  context "when a task is not executed" do
    it "does not call the system" do
      expect_no_system_call
      @task = fsc :build 
    end
  end

  context "when running on windows", windows: true do
    it 'calls "mono fsc"' do
      expect_compiler_call do |opts|
        expect(opts.executable).to eq "fsc"
      end
      invoke_fsc_task
    end
  end

  context "when running on non-windows", windows: false do
    it 'calls "mono fsc"' do
      expect_compiler_call do |opts|
        expect(opts.executable).to eq "fsharpc"
      end
      invoke_fsc_task
    end
  end
end
