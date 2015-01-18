describe 'fsharp' do
  before :each do
    @app = Rake::Application.new
    Rake.application = @app
  end

  context "when a task is not executed" do
    it "does not call the system" do
      expect(Kernel).to_not receive(:system)
      @task = fsc :build 
    end
  end

  context "when running on windows" do
    before :each do
      allow(@app).to receive("windows?").and_return true
    end

    it 'calls "mono fsc"' do
      expect(Kernel).to receive(:system) do |args|
        expect(args).to eq "fsc"
        true
      end
      @task = fsc :build
      @task.invoke()
    end
  end

  context "when running on non-windows" do
    before :each do
      allow(@app).to receive("windows?").and_return false
    end

    it 'calls "mono fsc"' do
      expect(Kernel).to receive(:system) do |args|
        expect(args).to eq "mono fsharpc"
        true
      end
      @task = fsc :build 
      @task.invoke()
    end
  end
end
