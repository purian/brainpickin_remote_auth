require 'digest/md5'
require 'active_support/core_ext/object' #gives us Hash.to_query

##
# Provides a helper to use brainpickin's SSO/remote auth service.
# see: https://my.brainpickin.com/aremote_authentication/doc
module Brainpickin

  ##
  # Handles storing the token and auth_url (endpoint) for the brainpickin side.
  class RemoteAuth
    class << self
      attr_writer :auth_url, :token

      def token
        raise ArgumentError.new('brainpickin token must be set. Set with Brainpickin::RemoteAuth.token = <token>') unless @token
        @token
      end

      def auth_url
        raise ArgumentError.new('brainpickin auth_url must be set. Set with Brainpickin::RemoteAuth.auth_url = <url>') unless @auth_url
        @auth_url
      end
    end
  end

  ##
  # Provides the method that generates the auth url. Mixin where required.
  module RemoteAuthHelper
    ##
    # Takes a hash of parameters and generates the hashed auth
    # url. The hash must include the :name and :email for the user.
    # See: https://my.brainpickin.com/aremote_authentication/doc for a list
    # of all of the parameters.
    #
    # If the :timestamp is not provided, Time.now will be used. If an
    # :external_id is provided, then the :hash will be generated.
    #
    # As a convenience, a user object can be passed instead, but must
    # respond_to? at least :email and :name. The :id of the user
    # object will be used as the :external_id.

    def brainpickin_remote_auth_url(user_or_params)
      params = user_or_params.is_a?(Hash) ? user_or_params : user_to_params(user_or_params)
      validate_params(params)
      params[:timestamp] = Time.now.utc.to_i unless params[:timestamp]
      params[:hash] = params[:external_id] ? generate_hash(Brainpickin::RemoteAuth.token, params) : ''

      "#{Brainpickin::RemoteAuth.auth_url}?#{params.to_query}"
    end

    private
    def user_to_params(user)
      params = { }
      [[:email, :email],
       [:name, :name],
       [:external_id, :id]].each do |param, field|
        params[param] = user.send(field) if user.respond_to?(field)
      end
      params
    end

    def validate_params(params)
      [:email, :name].each do |param|
        raise ArgumentError.new("Required parameter :#{param} not given") unless params[param]
      end
    end
    
    def generate_hash(token, params)
      str_to_hash = []
      str_to_hash << params[:name]
      str_to_hash << params[:email]
      str_to_hash << params[:external_id]
      str_to_hash << params[:interests]
      str_to_hash << params[:remote_photo_url]
      str_to_hash << token
      str_to_hash << params[:timestamp]
      input = str_to_hash.join("|")
      Digest::MD5.hexdigest(input)
    end

  end
end
