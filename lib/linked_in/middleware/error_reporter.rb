module LinkedIn
  class ErrorReporter < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do
        response = env[:response]
        case response.status
        when 401
          raise LinkedIn::Errors::UnauthorizedError.new(response), "(#{response.status}): #{response.body}"
        when 400
          raise LinkedIn::Errors::GeneralError.new(response), "(#{response.status}): #{response.body}"
        when 403
          raise LinkedIn::Errors::AccessDeniedError.new(response), "(#{response.status}): #{response.body}"
        when 404
          raise LinkedIn::Errors::NotFoundError, "(#{response.status}): #{response.body}"
        when 500
          raise LinkedIn::Errors::InformLinkedInError, "LinkedIn had an internal error. Please let them know in the forum. (#{response.status}): #{response.body}"
        when 502..503
          raise LinkedIn::Errors::UnavailableError, "(#{response.status}): #{response.body}"
        end
      end
    end
  end
end