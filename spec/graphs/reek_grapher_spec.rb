require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe ReekGrapher do 
  before :each do
    @reek_grapher = MetricFu::ReekGrapher.new
    MetricFu.configuration
  end
  
  it "should respond to reek_count and labels" do
    @reek_grapher.should respond_to(:reek_count)
    @reek_grapher.should respond_to(:labels)
  end
  
  describe "responding to #initialize" do
    it "should initialise reek_count and labels" do
      @reek_grapher.reek_count.should == {}
      @reek_grapher.labels.should == {}
    end
  end
  
  describe "responding to #get_metrics" do
    before(:each) do
      @metrics = YAML::load(File.open(File.join(File.dirname(__FILE__), "..", "resources", "yml", "20090630.yml")))
      @date = "01022003"
    end
    
    it "should set a hash of code smells to reek_count" do
      @reek_grapher.get_metrics(@metrics, @date)
      @reek_grapher.reek_count.should == {
        "Uncommunicative Name" => [27],
        "Feature Envy" => [20],
        "Utility Function" => [15],
        "Long Method" => [26],
        "Nested Iterators" => [12],
        "Control Couple" => [4],
        "Duplication" => [48],
        "Large Class" => [1] 
      }
      puts @reek_grapher.reek_count.inspect
    end
    
    it "should update labels with the date" do
      @reek_grapher.labels.should_receive(:update).with({ 0 => "01022003" })
      @reek_grapher.get_metrics(@metrics, @date)
    end
  end
  
  describe "responding to #graph!" do
    it "should write reek.png" do
      @reek_grapher.graph!
      lambda{ File.open(File.join(MetricFu.output_directory, 'reek.png')) }.should_not raise_error
    end
  end
end
