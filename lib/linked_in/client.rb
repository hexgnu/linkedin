require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryMethods
    include Api::UpdateMethods
    include Search

    attr_reader :client_id, :client_secret, :access_token

    def initialize(client_id=LinkedIn.client_id,
                   client_secret=LinkedIn.client_secret,
                   access_token=nil)
      @client_id     = client_id
      @client_secret = client_secret
      @access_token  = access_token
    end
  end

end
