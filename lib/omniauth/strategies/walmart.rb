require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Walmart < OmniAuth::Strategies::OAuth2
      option :name, "walmart"


      # https://login.account.wal-mart.com/authorize?responseType=code&clientId=66874dfd-1d5g-476v-8k2c-e22g46c6727k&redirectUri=https://example-client-app.com/resource/applanding&%20nonce=AVE1DCZ5FG&state=A0YFFJJQMD&clientType=seller
      option :client_options, {
        site: 'https://marketplace.walmartapis.com',
        authorize_url: 'https://login.account.wal-mart.com/authorize',
        token_url:  'https://marketplace.walmartapis.com/v3/token'
        
      }
      
      option :token_params, { grant_type: 'authorization_code' }
      option :provider_ignores_state, true
      
      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        super
      end

      protected
      
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
           
    end
  end
end