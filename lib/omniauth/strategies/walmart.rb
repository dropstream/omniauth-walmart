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
        Rails.logger.info "RequestPhase:..authorize_params...#{authorize_params}"

        auth_params = { 'redirectUri' => callback_url }.merge(authorize_params)
        Rails.logger.info "RequestPhase:..auth_params...#{auth_params}"

        redirect client.authorize_url(auth_params)
      end

      def authorize_params
        super
      end

      def token_params
        @seller_id = request.params['sellerId']
        Rails.logger.info "TokenParams:..seller_id...#{seller_id}"

        params = options.token_params.merge(options_for("token")).merge(pkce_token_params)
        headers = {
            'WM_PARTNER.ID' => request.params['sellerId'],
            'WM_QOS.CORRELATION_ID' => SecureRandom.uuid,
            'WM_SVC.NAME' =>  'Walmart Marketplace',
            'Accept' => 'application/json'
        }
        Rails.logger.info "TokenParams:..params...#{params}"
        Rails.logger.info "TokenParams:..headers...#{headers}"

        params.merge!('headers' => headers)
      end

      # def callback_phase # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      #   error = request.params["error_reason"] || request.params["error"]
      #   Rails.logger.info "CallbackPhase:..error...#{error}"

      #   if !options.provider_ignores_state && (request.params["state"].to_s.empty? || !secure_compare(request.params["state"], session.delete("omniauth.state")))
      #     Rails.logger.info "CallbackPhase:..if.."

      #     fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
      #   elsif error
      #     Rails.logger.info "CallbackPhase:..elsif.."

      #     fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
      #   else
      #     Rails.logger.info "CallbackPhase:..else.."

      #     self.access_token = build_access_token
      #     self.access_token = access_token.refresh! if access_token.expired?
      #     super
      #   end
      # rescue ::OAuth2::Error, CallbackError => e
      #   Rails.logger.info "CallbackPhase:..CallbackError..#{e.message}"

      #   fail!(:invalid_credentials, e)
      # rescue ::Timeout::Error, ::Errno::ETIMEDOUT, ::OAuth2::TimeoutError, ::OAuth2::ConnectionError => e
      #   fail!(:timeout, e)
      # rescue ::SocketError => e
      #   fail!(:failed_to_connect, e)
      # end

      protected

      def build_access_token
        verifier = request.params["code"]
        Rails.logger.info "build_access_token:..verifier..#{verifier}"
        build_access_token_params = {:redirect_uri => callback_url}.merge(token_params)
        Rails.logger.info "build_access_token:..build_access_token_params..#{build_access_token_params}"
        Rails.logger.info "build_access_token:..client.auth_code..#{client.inspect}"

        client.auth_code.get_token(verifier, build_access_token_params, deep_symbolize(options.auth_token_params))
      end     
      
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
           
    end
  end
end