module LinkedIn
	module Api

		module CommunicationMethods
		
			MAILBOX_PATH = '/people/~/mailbox'

			MAILBOX_HEADERS = {
				'Content-Type'	=> 'application/json'
			}

			def get_messages
				get(MAILBOX_PATH)
			end

			def send_message(subject, body, recipients)
				message = {
					:recipients	=> message_recipients(recipients),
					:subject		=> subject,
					:body				=> body
				}
				res = post(MAILBOX_PATH, message.to_json, MAILBOX_HEADERS)
				res.code.to_i == 201
			end

			# oauth_header must be the 'x-li-auth-token' header with value of the
			# form 'name:value' like the one returned on the standard_profile field
			#
			# TODO here: add email way to 'catch' recipients
			# subject is ignored when using ID + oauth_token
			def send_invite(subject, body, recipient, oauth_header)
				throw "LinkedIn::Error -> oauth_header must contain x-li-auth-token" if oauth_header[:name] != 'x-li-auth-token'
				message = {
					:recipients			=> message_recipients(recipient),
					:subject				=> subject,
					:body						=> body,
					"item-content"	=> {
						"invitation-request"	=> {
							"connect-type"	=> "friend",
							"authorization"	=> {
								"name"	=> oauth_header[:value].split(':').first,
								"value"	=> oauth_header[:value].split(':').last
							}
						}
					}
				}
				res = post(MAILBOX_PATH, message.to_json, MAILBOX_HEADERS)
				res.code.to_i == 201
			end

################################################################################

			private
			
################################################################################

			def message_recipients(recipients)
				{
					:values => (recipients.is_a?(Array) ? recipients : [recipients]).map{|recipient| {
						:person => {
							:_path => person_path(recipient)
						}
					}}
				}
			end

		end

	end
end
