require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryMethods
    include Api::UpdateMethods
    include Search

    attr_reader :client_id, :client_secret, :access_token

    # The first two arguments must be your client_id, and client_secret.
    # The third option may either be an access_token or an options hash.
    def initialize(client_id=LinkedIn.client_id,
                   client_secret=LinkedIn.client_secret,
                   initial_access_token=nil,
                   options={})
      @client_id     = client_id
      @client_secret = client_secret
      if initial_access_token.is_a? Hash
        @client_options = initial_access_token
      else
        @client_options = options
        self.set_access_token initial_access_token
      end
    end
  end

end
