require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryMethods
    include Api::UpdateMethods
    include Search

    attr_reader :client_id, :client_secret

    def initialize(client_id=LinkedIn.client_id,
                   client_secret=LinkedIn.client_secret,
                   initial_access_token=nil,
                   options={})
      @client_id     = client_id
      @client_secret = client_secret
      if initial_access_token.is_a? Hash
        @access_token  = nil
        @client_options = initial_access_token
      else
        @access_token  = initial_access_token
        @client_options = options
      end
    end
  end

end
