require File.join(File.dirname(__FILE__), 'spec_helper')

describe Txtlocal::Config do
  let(:config) { Txtlocal::Config.new }

  describe "attributes" do
    attributes = %w(test from username password)
    attributes.each do |attr|
      it "should have the '#{attr}' attribute" do
        value = mock("value")
        config.send("#{attr}=", value)
        config.send(attr).should == value
      end
    end
  end

  describe "defaults" do
    defaults = {
      :test => false,
      :username => nil,
      :password => nil,
      :from => nil
    }

    defaults.each_pair do |attr, default|
      example "#{attr} should default to #{default.inspect}" do
        config.send(attr).should == default
      end
    end
  end

  describe "testing?" do
    it "should return false if test isnt true" do
      config.testing?.should be_false
    end
    it "should return true if test is true" do
      config.test = true
      config.testing?.should be_true
    end
  end

end
