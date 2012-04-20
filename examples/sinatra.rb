require "rubygems"
require "haml"
require "sinatra"
require "linkedin"

enable :sessions

helpers do
  def login?
    !session[:atoken].nil?
  end
  
  def profile
    linkedin_client.profile unless session[:atoken].nil?
  end
  
  def connections
    linkedin_client.connections unless session[:atoken].nil?
  end
  
  private
  def linkedin_client
    client = LinkedIn::Client.new(settings.api, settings.secret)
    client.authorize_from_access(session[:atoken], session[:asecret])
    client
  end 
  
end

configure do
  # get your api keys at https://www.linkedin.com/secure/developer
  set :api, "your_api_key"
  set :secret, "your_secret"
end

get "/" do
  haml :index
end

get "/auth" do
  client = LinkedIn::Client.new(settings.api, settings.secret)
  request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}/auth/callback")
  session[:rtoken] = request_token.token
  session[:rsecret] = request_token.secret

  redirect client.request_token.authorize_url
end

get "/auth/logout" do
   session[:atoken] = nil
   redirect "/"
end

get "/auth/callback" do
  client = LinkedIn::Client.new(settings.api, settings.secret)
  if session[:atoken].nil?
    pin = params[:oauth_verifier]
    atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
    session[:atoken] = atoken
    session[:asecret] = asecret    
  end
  redirect "/"
end


__END__
@@index
-if login?
  %p Welcome #{profile.first_name}!
  %a{:href => "/auth/logout"} Logout
  %p= profile.headline
  %br
  %div= "You have #{connections.total} connections!"
  -connections.all.each do |c|
    %div= "#{c.first_name} #{c.last_name} - #{c.headline}"
-else
  %a{:href => "/auth"} Login using LinkedIn
