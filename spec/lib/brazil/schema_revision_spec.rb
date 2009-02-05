require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Brazil::SchemaRevision do
  before(:each) do
    @major = 3
    @minor = 14
    @patch = 6
    
    @schema_revision = Brazil::SchemaRevision.new(@major, @minor, @patch)
  end

  it "should be an schema_revision instance given valid attributes" do
    @schema_revision.should_not be_nil
  end
  
  it "should return the previous version when calling prev" do
    @schema_revision.prev.should == (Brazil::SchemaRevision.new(@major, @minor, (@patch-1)))
  end
  
  it "should return the next version when calling next" do
    @schema_revision.next.should == (Brazil::SchemaRevision.new(@major, @minor, (@patch+1)))
  end
  
  describe "when calling to_s" do
    it "should return a three part version as string" do
      @schema_revision.to_s.should == "3_14_6"
    end
    
    it "should return a two part version as string" do
      Brazil::SchemaRevision.new(@major, @minor, nil).to_s.should == "3_14"
    end
    
    it "should return a one part version as string" do
      Brazil::SchemaRevision.new(@major, nil, nil).to_s.should == "3"
    end
  end
  
  describe "when calling <=>" do
    it "should be less than this revision" do
      @schema_revision.<=>(@schema_revision.next).should eql(-1)
    end
    
    it "should be equal to this revision" do
      @schema_revision.<=>(Brazil::SchemaRevision.new(@major, @minor, @patch)).should eql(0)
    end
    
    it "should be more than this revision" do
      @schema_revision.<=>(@schema_revision.prev).should eql(1)
    end
  end
  
  describe "when calling include?" do
    it "should say that 3_14_6_2 is included" do
      @schema_revision.include?(Brazil::SchemaRevision.from_string('3_14_6_2')).should be_true
    end
    
    it "should say that 3_15 is not included" do
      @schema_revision.include?(Brazil::SchemaRevision.from_string('3_15')).should be_false
    end
  end
  
  describe "when calling to_a" do
    it "should return a three part version as an array" do
      @schema_revision.to_a.should == [3, 14, 6]
    end
    
    it "should return a two part version as an array" do
      Brazil::SchemaRevision.new(@major, @minor, nil).to_a.should == [3, 14]
    end
    
    it "should return a one part version as an array" do
      Brazil::SchemaRevision.new(@major, nil, nil).to_a.should == [3]
    end
  end
  
  describe "when calling major" do
    it "should return the major number" do
      @schema_revision.major.should eql(3)
    end
    
    it "should return 0 if the major number is nil" do
      Brazil::SchemaRevision.new(nil, nil, nil).patch.should eql(0)
    end
  end
  
  describe "when calling minor" do
    it "should return the minor number" do
      @schema_revision.minor.should eql(14)
    end
    
    it "should return 0 if the minor number is nil" do
      Brazil::SchemaRevision.new(@major, nil, nil).minor.should eql(0)
    end
  end
  
  describe "when calling patch" do
    it "should return the patch number" do
      @schema_revision.patch.should eql(6)
    end
    
    it "should return 0 if the patch number is nil" do
      Brazil::SchemaRevision.new(@major, @minor, nil).patch.should eql(0)
    end
  end
    
end
