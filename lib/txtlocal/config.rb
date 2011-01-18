module Txtlocal
  class Config

    # The default FROM value for sent messages
    # this can be overridden on a per-message basis
    attr_accessor :from

    # The username of the txtlocal account to use when accessing the API
    attr_accessor :username

    # The password of the txtlocal account to use when accessing the API
    attr_accessor :password

    # Access the API in test mode
    attr_accessor :test

    def initialize
      @test = false
    end

    # Nice wrapper to check if we're testing
    def testing?
      !!@test
    end

  end
end
