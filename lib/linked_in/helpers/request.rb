module LinkedIn
	module Helpers

		module Request

			DEFAULT_HEADERS = {
				'x-li-format' => 'json'
			}

			API_PATH = '/v1'

################################################################################

			protected

################################################################################

	    def person_path(options)
	      path = "/people/"
	      if options[:id]
	        path += "id=#{options[:id]}"
	      elsif options[:url]
	        path += "url=#{CGI.escape(options[:url])}"
	      else
	        path += "~"
	      end
	    end

      def company_path(options)
        path = "/companies/"
        if options[:id]
          path += "id=#{options[:id]}"
        elsif options[:url]
          path += "url=#{CGI.escape(options[:url])}"
        elsif options[:name]
          path += "universal-name=#{CGI.escape(options[:name])}"
        elsif options[:domain]
          path += "email-domain=#{CGI.escape(options[:domain])}"
        else
          path += "~"
        end
      end

			def get(path, options={})
				if LinkedIn.debug
			 		puts "LinkedIn::GET #{API_PATH}#{path}"
					start = Time.now
				end
				response = access_token.get("#{API_PATH}#{path}", DEFAULT_HEADERS.merge(options))
				if LinkedIn.debug
					puts "Done in #{((Time.now-start) * 100).to_i}ms"
					puts "Response: #{response.inspect}"
				end
				raise_errors(response)
				response.body
			end

			def post(path, body='', options={})
				if LinkedIn.debug
					puts "LinkedIn::POST #{API_PATH}#{path}"
					puts "with body: #{body.inspect}"
					start = Time.now
				end
				response = access_token.post("#{API_PATH}#{path}", body, DEFAULT_HEADERS.merge(options))
				if LinkedIn.debug
					puts "Done in #{((Time.now-start) * 100).to_i}ms"
					puts "Response: #{response.inspect}"
				end
				raise_errors(response)
				response
			end

			def put(path, body, options={})
				if LinkedIn.debug
					puts "LinkedIn::PUT #{API_PATH}#{path}"
					start = Time.now
				end
				response = access_token.put("#{API_PATH}#{path}", body, DEFAULT_HEADERS.merge(options))
				if LinkedIn.debug
					puts "Done in #{((Time.now-start) * 100).to_i}ms"
					puts "Response: #{response.inspect}"
				end
				raise_errors(response)
				response
			end

			def delete(path, options={})
				if LinkedIn.debug
					puts "LinkedIn::DELETE #{API_PATH}#{path}"
					start = Time.now
				end
				response = access_token.delete("#{API_PATH}#{path}", DEFAULT_HEADERS.merge(options))
				if LinkedIn.debug
					puts "Done in #{((Time.now-start) * 100).to_i}ms"
					puts "Response: #{response.inspect}"
				end
				raise_errors(response)
				response
			end

################################################################################

			private

################################################################################

			def raise_errors(response)
				# Even if the json answer contains the HTTP status code, LinkedIn also sets this code
				# in the HTTP answer (thankfully).
				case response.code.to_i
				when 401
					data = Mash.from_json(response.body)
					raise LinkedIn::Errors::UnauthorizedError.new(data), "(#{data.status}): #{data.message}"
				when 400, 403
					data = Mash.from_json(response.body)
					raise LinkedIn::Errors::GeneralError.new(data), "(#{data.status}): #{data.message}"
				when 404
					raise LinkedIn::Errors::NotFoundError, "(#{response.code}): #{response.message}"
				when 500
					raise LinkedIn::Errors::InformLinkedInError, "LinkedIn had an internal error. Please let them know in the forum. (#{response.code}): #{response.message}"
				when 502..503
					raise LinkedIn::Errors::UnavailableError, "(#{response.code}): #{response.message}"
				end
			end

			def to_query(options)
				URI.encode_www_form(options)
			end

			def to_uri(path, options)
				uri = URI.parse(path)

				if options && options != {}
					uri.query = to_query(options)
				end
				uri.to_s
			end

		end

	end
end
