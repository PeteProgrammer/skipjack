require 'fakefs/spec_helpers'

def invoke_fsc *args, &block
  opts = nil
  expect_compiler_call do |o|
    opts = o
  end
  args = ["dummy.exe"] if args == []
  task = fsc *args do |t|
    yield t if block_given?
  end
  task.invoke
  opts
end

describe 'fsharp' do
  include FakeFS::SpecHelpers

  before :each do |example|
    @app = Rake.application = Rake::Application.new

    # mock if we are running windows or not
    windows = example.metadata[:windows]
    windows = true if windows.nil?
    allow(@app).to receive("windows?").and_return windows

    allow(Kernel).to receive(:system).and_return true
  end

  context "when a task is not invoked" do
    it "does not call the system" do
      expect_no_system_call
      @task = fsc "dummy.exe"
    end
  end

  describe "command line args" do
    describe "called executable" do
      subject do
        opts = invoke_fsc
        opts.executable
      end

      context "when running on windows", windows: true do
        it { should eq "fsc" }
      end

      context "when running on non-windows", windows: false do
        it { should eq "fsharpc" }
      end
    end

    describe "--reference: argument" do
      before do |ex|
        @opts = invoke_fsc do |t|
          t.references = ["ref1.dll", "ref2.dll"]
        end
      end

      subject { @opts.references }

      it { should eq ["ref1.dll", "ref2.dll"] }
    end

    describe "--resident" do
      before do |ex|
        @opts = invoke_fsc do |t|
          t.resident = ex.metadata[:resident] unless ex.metadata[:resident].nil?
        end
      end

      subject { @opts.resident }

      context "resident is not set" do
        it "defaults to true" do
          expect(subject).to eq true
        end
      end

      context "resident set to true", resident: true do
        it { should eq true }
      end

      context "resident set to false", resident: false do
        it { should eq false }
      end
    end

    describe "--target: argument" do
      before do |ex|
        @opts = invoke_fsc do |t|
          t.target = ex.metadata[:target]
        end
      end

      subject { @opts.target }

      context "when target = :library", target: :library do
        it { should eq "library" }
      end

      context "when target = :exe", target: :exe do
        it { should eq "exe" }
      end
    end

    describe "source files" do
      it "contains the passed sources" do
        sources = ["source1.fs", "source2.fs"]
        FileUtils.touch "source1.fs"
        FileUtils.touch "source2.fs"
        @opts = invoke_fsc do |t|
          t.source_files = sources
        end
        expect(@opts.source_files).to eq(sources)
      end
    end

    describe "output" do
      it "sets the output file" do
        @opts = invoke_fsc "f/p.exe" do |t|
        end
        expect(@opts.out).to eq("f/p.exe")
      end
    end

    describe "build optimization" do
      context "build output is older than source files" do
        it "calls the compiler" do
          FileUtils.touch('./p.exe')
          FileUtils.touch('s.fs')
          @opts = invoke_fsc "p.exe" do |t|
            t.target = :exe
            t.source_files = ["s.fs"]
          end
          expect(@opts).to_not be_nil
        end
      end

      context "build output is newer than source files" do
        it "does not call the compiler" do
          FileUtils.touch('s.fs')
          FileUtils.touch('./p.exe')
          @opts = invoke_fsc "p.exe" do |t|
            t.target = :exe
            t.source_files = ["s.fs"]
          end
          expect(@opts).to be_nil
        end
      end

      it "does not copy the source file to the destination folder by default" do
          FileUtils.mkdir('input', 'output')
          FileUtils.touch('input/x.dll')
          task = fsc "output/p.exe" do |t|
            t.target = :exe
            t.add_reference 'input/x.dll'
          end
          task.invoke
          expect(File.file?('output/x.dll')).to be false
      end

      it "copies the source file to the destination folder" do
          FileUtils.mkdir('input', 'output')
          FileUtils.touch('input/x.dll')
          task = fsc "output/p.exe" do |t|
            t.target = :exe
            t.add_reference 'input/x.dll', copy_local: true
          end
          task.invoke
          expect(File.file?('output/x.dll')).to be true
      end

      it "doesnt copy if copy_local is false" do
          FileUtils.mkdir('output')
          FileUtils.touch('output/x.dll')
          task = fsc "output/p.exe" do |t|
            t.target = :exe
            t.add_reference 'input/x.dll', copy_local: false
          end
          task.invoke
          op = lambda { task.invoke }
          expect(op).to_not raise_error
      end
    end
  end

  describe "target type" do
    it "fails when using invalid target option" do
      op = lambda do
        task = fsc "p.exe" do |t|
          t.target = :invalid_option
        end
      end
      expect(op).to raise_error(/^Invalid target/)
    end
  end
end
