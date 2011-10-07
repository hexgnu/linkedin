module LinkedIn
  class Client < API

    require 'linked_in/client/profile'

    alias :api_endpoint :endpoint

    include LinkedIn::Client::Profile

  end
end
