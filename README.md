# Okta

Simple oauth2 shard to authenticate with OKTA

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     okta:
       github: xtokio/okta
   ```

2. Run `shards install`

## Usage

##### Example using Kemal
```crystal
require "kemal"
require "okta"

base_domain   = "example.com"
client_id     = "000111222333444555"
client_secret = "6667778889990000111122223334444555"
redirect_uri  = "http://localhost:3000/callback"
token_uri     = "https://okta.example.com/oauth2/111XXXAAAABBBCCCCC/v1/token"
authorize_uri = "https://okta.example.com/oauth2/111XXXAAAABBBCCCCC/v1/authorize"
user_info     = "/oauth2/111XXXAAAABBBCCCCC/v1/userinfo"
scope         = "openid profile email"
state         = "1234"

oauth2_client = Okta::Auth.new(base_domain,client_id,client_secret,redirect_uri,token_uri,authorize_uri,user_info,scope,state)


get "/login" do |env|
  env.redirect oauth2_client.authorize_url
end

get "/callback" do |env|
  puts "Got to the callback"
  authorization_code =  env.params.query["code"]
  user_info = oauth2_client.authenticate(authorization_code)

  name  = user_info["name"].to_s
  email = user_info["email"].to_s

  puts name
  puts email

  # Redirect after getting user info
  env.redirect "/success"
end

get "/success" do |env|
  puts "Success"
end
```


## Contributing

1. Fork it (<https://github.com/xtokio/okta/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Luis Gomez](https://github.com/xtokio) - creator and maintainer
