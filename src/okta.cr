require "http/client"
require "oauth2"
require "json"
require "./okta/*"

module Okta
  extend self

  class Auth
    property logged : Bool
    @logged  = false

    def initialize(base_domain : String,client_id : String,client_secret : String,redirect_uri : String,token_uri : String,authorize_uri : String,user_info : String,scope : String,state : String)
      @base_domain = base_domain
      @user_info   = user_info
      @scope       = scope
      @state       = state

      @oauth2_client = OAuth2::Client.new(
          host: @base_domain,
          client_id: client_id,
          client_secret: client_secret,
          authorize_uri: authorize_uri,
          token_uri: token_uri,
          redirect_uri: redirect_uri
      )
    end

    def authorize_url
      # Build an authorize URI
      authorize_url = @oauth2_client.get_authorize_uri(@scope, @state) do |form|
        form.add "nonce", "UBGW"
      end
      authorize_url
    end

    def authenticate(authorization_code : String)
      access_token = @oauth2_client.get_access_token_using_authorization_code(authorization_code)

      client = HTTP::Client.new(@base_domain, tls: true)
      access_token.authenticate(client)

      user = "{}"
      if access_token.access_token
        # Userinfo
        client_info = HTTP::Client.new(@base_domain, tls: true)
        client_info.before_request do |request|
          request.headers["Authorization"] = "Bearer #{access_token.access_token}"
        end
        response = client_info.get @user_info
        user = response.body
        @logged = true
      end
      JSON.parse(user)
    end

    def user_logged
      @logged
    end

  end

end
