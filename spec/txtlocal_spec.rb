require File.join(File.dirname(__FILE__), 'spec_helper')

describe Txtlocal do

  describe "config" do
    it "should be accessible" do
      Txtlocal.config.should be_a Txtlocal::Config
    end
    it "should be modifiable with a block" do
      remember = nil
      Txtlocal.config do |c|
        c.should be_a Txtlocal::Config
        remember = c
      end
      Txtlocal.config.should == remember
    end
    it "should be resettable" do
      c = Txtlocal.config
      Txtlocal.reset_config
      Txtlocal.config.should_not == c
    end
  end

  describe "send_message" do
    let(:message)      { double("message body") }
    let(:recipients)   { double("list of recipients") }
    let(:options)      { double("additional message options") }
    let(:msg_instance) { double("message instance") }

    it "should construct a Message instance and send! it" do
      msg_instance.should_receive(:send!).with(no_args)
      Txtlocal::Message.should_receive(:new).with(message, recipients, options) { msg_instance }
      Txtlocal.send_message(message, recipients, options).should == msg_instance
    end
  end

end
