require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Walmart < OmniAuth::Strategies::OAuth2
      attr_reader :seller_id

      option :name, "walmart_marketplace"

      option :client_options, {
        site: 'https://marketplace.walmartapis.com',
        authorize_url: 'https://login.account.wal-mart.com/authorize',
        token_url:  'https://marketplace.walmartapis.com/v3/token' 
      }
      
      option :token_params, { grant_type: 'authorization_code' }
      option :provider_ignores_state, true
      
      extra do
        {
          'seller_id' => seller_id
        }
      end

      def request_phase
        auth_params = { 'redirectUri' => callback_url }.merge(authorize_params)
        redirect client.authorize_url(auth_params)
      end

      def authorize_params
        super
      end

      def token_params
        @seller_id = request.params['sellerId']
        params = options.token_params.merge(options_for("token")).merge(pkce_token_params)
        headers = {
            'WM_PARTNER.ID' => request.params['sellerId'],
            'WM_QOS.CORRELATION_ID' => SecureRandom.uuid,
            'WM_SVC.NAME' =>  'Walmart Marketplace',
            'Accept' => 'application/json'
        }

        params.merge!('headers' => headers)
      end

      protected

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params), deep_symbolize(options.auth_token_params))
      end     
      
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
           
    end
  end
end