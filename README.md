# OmniAuth::Acumatica

OmniAuth OAuth2 strategy for Walmart Marketplace

## Usage

Authorization Code Flow
https://developer.walmart.com/doc/us/mp/us-mp-auth2/#606

You must first register your application:
https://developer.walmart.com/

When you register the application, you will get an 'Client ID' and 'Client Secret'. These need to be provided when you configure the strategy (this example assumes the values are available in environment variables):

```
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :walmart_marketplace, ENV['CLIENT_ID'], ENV['CLIENT_SECRET']
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-walmart'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-walmart

## Response Example

Expected from 3dcart:

```
{
    "access_token": "eyJraWQiOiI1MWY3MjM0Ny0wYWY5LTRhZ.....",
    "refresh_token": "APXcIoTpKMH9OQN....",
    "token_type": "Bearer",
    "expires_in": 900
}
```


## Contributing

1. Fork it ( https://github.com/dropstream/omniauth-walmart/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request