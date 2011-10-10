module LinkedIn
  class Client < API

    require 'linked_in/client/company'
    require 'linked_in/client/group'
    require 'linked_in/client/profile'

    alias :api_endpoint :endpoint

    include LinkedIn::Client::Company
    include LinkedIn::Client::Group
    include LinkedIn::Client::Profile

  end
end
