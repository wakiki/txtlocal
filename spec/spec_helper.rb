require 'rspec'

require 'txtlocal'

require 'webmock/rspec'

Rspec.configure do |c|
  c.mock_with :rspec
end
