require File.join(File.dirname(__FILE__), 'spec_helper')

describe Txtlocal::Config do

  describe "attributes" do
    attributes = %w(test from username password)
    let(:config) { Txtlocal::Config.new }
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
    let(:config) { Txtlocal::Config.new }
    defaults.each_pair do |attr, default|
      example "#{attr} should default to #{default.inspect}" do
        config.send(attr).should == default
      end
    end
  end

end
