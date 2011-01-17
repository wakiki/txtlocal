# txtlocal.co.uk API Wrapper

This gem is intended to provide a simple API for sending text messages via txtlocal's API.

## Installing

Add the gem to your gemfile

  gem 'txtlocal', :git => 'git://github.com/epigenesys/txtlocal.git'

## Usage

Configure the default settings

    Txtlocal.config do |c|
      c.from = "My App"
      c.username = "txtlocal_username"
      c.password = "txtlocal_password"
    end

Use Txtlocal.send_message to send messages

    Txtlocal.send_message("You have 1 new friend request!", "07729435xxx")

Or create a message manually

    msg = Txtlocal::Message.new
    msg.body = "Tickets will be available tomorrow morning at 9am"
    msg.recipients = ["0712 3893 xxx", "447923176xxx"]
    msg.add_recipient "+447729435xxx"
    msg.send!

You can override the sender on a per message basis

    Txtlocal.send_message("You have 1 new friend request!", "07729435xxx", :from => "someone")

    msg = Txtlocal::Message.new
    msg.from = "a mystery"

## Testing

Set test = true in the configuration to use the API's test mode

    Txtlocal.config.test = true
    Txtlocal.config.testing?
      => true
