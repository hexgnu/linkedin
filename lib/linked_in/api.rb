module LinkedIn
  module Api

    # @!macro person_path_options
    #  @param [Hash] options identifies the user profile you want
    #  @option options [String] :id a member token
    #  @option options [String] :url a Public Profile URL
    #  @option options [String] :email TODO

    # @!macro company_path_options
    #  @param [Hash] options identifies the user profile you want
    #  @option options [String] :domain company email domain
    #  @option options [String] :id company ID
    #  @option options [String] :url TODO
    #  @option options [String] :name company universal name
    #  @option options [String] :is_admin TODO

    # @!macro share_input_fields
    #  @param [Hash] share content of the share
    #  @option share [String] :comment
    #  @option share [String] :content
    #  @option share [String] :title
    #  @option share [String] :submitted_url TODO
    #  @option share [String] :submitted_image_url TODO
    #  @option share [String] :description
    #  @option share [String] :visibility
    #  @option share [String] :code

    autoload :QueryHelpers,  "linked_in/api/query_helpers"
    autoload :People,  "linked_in/api/people"
    autoload :Groups,  "linked_in/api/groups"
    autoload :Companies,  "linked_in/api/companies"
    autoload :Jobs,  "linked_in/api/jobs"
    autoload :ShareAndSocialStream,  "linked_in/api/share_and_social_stream"
    autoload :Communications, "linked_in/api/communications"
  end
end
