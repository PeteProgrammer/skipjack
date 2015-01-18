describe 'fsharp' do
  before :each do |example|
    @app = Rake::Application.new
    Rake.application = @app

    # mock if we are running windows or not
    windows = example.metadata[:windows]
    windows = true if windows.nil? #default to true as this is a simpler case (no mono prefix)
    allow(@app).to receive("windows?").and_return windows
    allow(Kernel).to receive(:system).and_return true
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

  describe "target type" do
    it "adds --target:library to library code" do
      expect_compiler_call do |opts|
        expect(opts.target).to eq "library"
      end
      invoke_fsc_task do |t|
        t.target = :library
      end
    end
    it "adds --target:exe to library exe" do
      expect_compiler_call do |opts|
        expect(opts.target).to eq "exe"
      end
      invoke_fsc_task do |t|
        t.target = :exe
      end
    end
    it "fails when using invalid target option" do
      op = lambda do
        invoke_fsc_task do |t|
          t.target = :invalid_option
        end
      end
      expect(op).to raise_error
    end
  end
end
