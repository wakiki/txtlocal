require File.join(File.dirname(__FILE__), 'spec_helper')

describe Txtlocal::Message do
  describe "initialize" do
    let(:new) { Txtlocal::Message.allocate }
    let(:body) { double("body text") }
    let(:recipients) { double("recipients") }
    let(:options) { double("options") }
    before(:each) do
      Txtlocal::Message.stub!(:new) do |*args|
        new.tap do |n|
          n.send :initialize, *args
        end
      end
    end

    it "should call internal setter methods" do
      new.should_receive(:body=).with(body)
      new.should_receive(:recipients=).with(recipients)
      new.should_receive(:options=).with(options)
      msg = Txtlocal::Message.new(body, recipients, options)
    end
  end

  describe "body text" do
    let(:msg) { Txtlocal::Message.new }
    describe "body" do
      it "should be accessible" do
        msg.body = "body text"
        msg.body.should == "body text"
      end
      it "should replace newlines with %n" do
        msg.body = "once\nupon\na time"
        msg.body.should == "once%nupon%na time"
      end
      it "should trim trailing and leading whitespace" do
        msg.body = "  a short message\n\n"
        msg.body.should == "a short message"
      end
    end
  end

  describe "recipients" do
    let(:msg) { Txtlocal::Message.new }
    describe "accessor" do
      it "should accept single value" do
        msg.recipients = "447729416732"
        msg.recipients.should == ["447729416732"]
      end
      it "should accept multiple values" do
        msg.recipients = ["447729416732", "447923732984"]
        msg.recipients.should == ["447729416732", "447923732984"]
      end
      it "should be using add_recipient internally" do
        msg.should_receive(:add_recipient).with("447729416732")
        msg.recipients = "447729416732"
      end
    end
    describe "add_recipient" do
      it "should accept txtlocal format number" do
        msg.add_recipient("447729416732")
        msg.recipients.should == ["447729416732"]
      end
      it "should accept 07 format number" do
        msg.add_recipient("07729416745")
        msg.recipients.should == ["447729416745"]
      end
      it "should accept international format number" do
        msg.add_recipient("+447729416745")
        msg.recipients.should == ["447729416745"]
      end
      it "should accept numbers with spaces" do
        msg.add_recipient("07729 457 756")
        msg.recipients.should == ["447729457756"]
      end
      it "should not add invalid numbers" do
        # TODO: exception here?
        msg.add_recipient("qwdcs")
        msg.add_recipient("0114 245 9832")
        msg.add_recipient("0800 800 8000")
        msg.recipients.should be_empty
      end
    end
  end

  describe "from" do
    let(:msg) { Txtlocal::Message.new }
    before(:each) do
      Txtlocal.config.from = "default"
    end
    after(:each) do
      Txtlocal.reset_config
    end
    it "should default to config.from" do
      msg.from.should == "default"
    end
    it "should be overridable" do
      msg.from = "overridden"
      msg.from.should == "overridden"
    end
    it "should revert to default if set to nil" do
      msg.from = "overridden"
      msg.from.should == "overridden"
      msg.from = nil
      msg.from.should == "default"
    end
    it "should truncate if set to longer than 11 characters" do
      msg.from = "123456789012345"
      msg.from.should == "12345678901"
    end
    it "should fail silently if set to less than 3 characters" do
      msg.from = "12"
      msg.from.should == "default"
    end
    it "should trim whitespace and remove any non alphanumeric or space characters" do
      msg.from = " a person! "
      msg.from.should == "a person"
    end
  end

  describe "options" do
    let(:msg) { Txtlocal::Message.new }
    it "should accept :from" do
      msg.options = {:from => "my name"}
      msg.from.should == "my name"
    end
  end

  describe "send!" do
    context "web mocked" do
      before(:each) do
        WebMock.disable_net_connect!
        stub_request(:post, "https://www.txtlocal.com/sendsmspost.php")
        Txtlocal.config do |c|
          c.from = "testing"
          c.username = "testuser"
          c.password = "testpass"
          c.test = false
        end
      end
      after(:each) do
        Txtlocal.reset_config
      end
      it "should send data to the API endpoint" do
        msg = Txtlocal::Message.new("a message", "447729416583")
        msg.send!
        WebMock.should have_requested(:post, "https://www.txtlocal.com/sendsmspost.php").with(
          :body => {'uname' => "testuser", 'pword' => "testpass", 'json' => '1', 'test' => '0',
                    'from' => "testing", 'selectednums' => "447729416583", 'message' => "a message"}
        )
      end
      it "should comma sepratate multiple recipients" do
        msg = Txtlocal::Message.new("a message", ["447729416583", "447984534657"])
        msg.send!
        WebMock.should have_requested(:post, "https://www.txtlocal.com/sendsmspost.php").with(
          :body => {'uname' => "testuser", 'pword' => "testpass", 'json' => '1', 'test' => '0',
                    'from' => "testing", 'selectednums' => "447729416583,447984534657",
                    'message' => "a message"}
        )
      end
    end
    context "api test mode" do
      if not (File.readable?('api_login.rb') and load('api_login.rb') and
              API_USERNAME and API_PASSWORD)
        pending "\n" +
          "Please create a file api_login.rb that defines API_USERNAME and API_PASSWORD " +
          "to run tests against the real server"
      else
        before(:each) do
          WebMock.allow_net_connect!
          Txtlocal.config do |c|
            c.from = "testing"
            c.username = API_USERNAME
            c.password = API_PASSWORD
            c.test = true
          end
        end
        it "should send data to the API endpoint" do
          msg = Txtlocal::Message.new("a message", "447729467413")
          msg.send!
          msg.response.should_not be_nil
          msg.response[:error].should include "testmode"
        end
      end
    end
  end
end
