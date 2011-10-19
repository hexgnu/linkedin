module LinkedIn
  class Client < API

    require 'linked_in/client/company'
    require 'linked_in/client/group'
    require 'linked_in/client/job'
    require 'linked_in/client/profile'
    require 'linked_in/client/social_stream'

    alias :api_endpoint :endpoint

    include LinkedIn::Client::Company
    include LinkedIn::Client::Group
    include LinkedIn::Client::Job
    include LinkedIn::Client::Profile
    include LinkedIn::Client::SocialStream

  end
end
