module LinkedIn

	# This class is made to mock LinkedIn JSON responses to our requests

  class Mocker
  
  	def answer(uri)
    	puts "LinkedIn::Mocker as to answer \"#{uri}\"" if LinkedIn.debug
    	if uri.start_with?('/people-search')
    		return search
    	elsif uri.start_with?('/people/~/connections')
    		return connections
    	elsif uri.start_with?('/people/~/network/updates')
    		return network_updates
    	elsif uri.start_with?('/people/~')
    		return me
    	elsif uri.start_with?('/people')
    		return other
    	end
  		throw "LinkedIn::Mocker doesn't known how to answer this"
  	end

  	###

  	def me
  		local_mock('profiles/me').to_json
  	end
  	def connections
  		local_mock('connections').to_json
  	end
  	def network_updates
  		local_mock('network_updates').to_json
  	end
  	def other
  		local_mock('profiles/toto').to_json
  	end
  	def search
  		s = local_mock('search_results')
  		s["people"]["_count"] = 2
  		s["people"]["values"] << local_mock('profiles/obama')
  		s["people"]["values"] << local_mock('profiles/toto')
  		s.to_json
  	end
  	
  	private
  	
  	def local_mock(path)
  		YAML::load(File.open(File.expand_path("../../../mock/#{path}.yml", __FILE__)))
  	end
  
  end
  
end
