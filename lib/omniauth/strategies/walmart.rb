require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Walmart < OmniAuth::Strategies::OAuth2
      option :name, "walmart_marketplace"

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

      def token_params
        params = options.token_params.merge(options_for("token")).merge(pkce_token_params)
        headers = {
            'WM_PARTNER.ID' => request.params['sellerId'],
            'WM_QOS.CORRELATION_ID' => SecureRandom.uuid,
            'WM_SVC.NAME' =>  'Walmart Marketplace'
        }
        params.merge!('headers' => headers)
      end

      protected
      
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
           
    end
  end
end