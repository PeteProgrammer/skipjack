describe 'fsharp' do
  before :each do |example|
    @app = Rake::Application.new
    Rake.application = @app

    # mock if we are running windows or not
    windows = example.metadata[:windows]
    windows = true if windows.nil?
    allow(@app).to receive("windows?").and_return windows

    allow(Kernel).to receive(:system).and_return true
  end

  context "when a task is not executed" do
    it "does not call the system" do
      expect_no_system_call
      @task = fsc :build 
    end
  end

  describe "command line args" do
    let :options do
      expect_compiler_call { |opts| @opts = opts }
      invoke_fsc_task do |t|
        @setup.call(t) if @setup
      end
      @opts
    end

    describe "called executable" do
      subject { options.executable }

      context "when running on windows", windows: true do
        it { should eq "fsc" }
      end

      context "when running on non-windows", windows: false do
        it { should eq "fsharpc" }
      end
    end

    describe "--target: argument" do
      before do |ex|
        @setup = lambda do |t|
          t.target = ex.metadata[:target]
        end
      end

      subject { options.target }

      context "when target = :library", target: :library do
        it { should eq "library" }
      end

      context "when target = :exe", target: :exe do
        it { should eq "exe" }
      end
    end
  end

  describe "target type" do
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
