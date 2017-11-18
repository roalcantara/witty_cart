# frozen_string_literal: true

require 'json'
require 'net/https'
require 'cgi'

# :nocov:
module Woopra
  # rubocop:disable Metrics/ClassLength
  class Tracker
    CONFIGURATION_KEY = :woopra_configuration
    REQUEST_FORWARDED_HEADER = 'HTTP_X_FORWARDED_FOR'
    REQUEST_USER_AGENT_HEADER = 'HTTP_USER_AGENT'
    SDK_ID = 'rails'

    # rubocop:disable Style/ClassVars
    @@default_config = {
      domain: '',
      cookie_name: 'wooTracker',
      cookie_domain: '',
      cookie_path: '/',
      ping: true,
      ping_interval: 12_000,
      idle_timeout: 300_000,
      download_tracking: true,
      outgoing_tracking: true,
      download_pause: 200,
      outgoing_pause: 400,
      ignore_query_url: true,
      hide_campaign: false,
      ip_address: '',
      cookie_value: ''
    }

    attr_reader :response

    def self.add_configuration_to_current_thread(request)
      Thread.current[CONFIGURATION_KEY] = {
        domain: request.host,
        cookie_domain: request.host,
        ip_address: get_ip_address(request),
        cookie_value: request.cookies[@@default_config[:cookie_name]] || random_cookie,
        user_agent: request.env[REQUEST_USER_AGENT_HEADER],
        url: request.url.to_s
      }
    end

    def self.current_configuration
      Thread.current[CONFIGURATION_KEY]
    end

    def self.get_ip_address(request)
      if request.env[REQUEST_FORWARDED_HEADER].present?
        request.env[REQUEST_FORWARDED_HEADER].split(',')[0].strip
      else
        request.remote_ip
      end
    end

    def self.random_cookie
      o = [('0'..'9'), ('A'..'Z')].map(&:to_a).flatten
      (0...12).map { o[rand(o.length)] }.join
    end

    def initialize(configuration)
      @current_config = @@default_config.merge(configuration)
      @custom_config = { app: SDK_ID }
      @user = {}
      @events = []
      @user_up_to_date = true
      @has_pushed = false
    end

    def config(data)
      data.each do |key, value|
        next unless @@default_config.key?(key)
        @current_config[key] = value
        if key != :ip_address && key != :cookie_value
          @custom_config[key] = value
        end
      end
    end

    def identify(user)
      @user = user
      @user_up_to_date = false
      self
    end

    def track(*p)
      event_name = nil
      event_data = nil
      back_end_tracking = false

      p.each do |param|
        case param
        when String
          event_name = param.to_s
        when Hash
          event_data = param
        when TrueClass
          back_end_tracking = param
        end
      end

      if back_end_tracking
        @response = woopra_http_request(true, [event_name, event_data])
      else
        @events << [event_name, event_data]
      end

      self
    end

    def push(back_end_tracking = false)
      return unless @user_up_to_date

      if back_end_tracking
        @response = woopra_http_request(false)
      else
        @has_pushed = true
      end
    end

    private

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def woopra_http_request(is_tracking, event = nil)
      base_url = 'www.woopra.com'
      get_params = {}

      # Configuration
      get_params['host'] = @current_config[:domain].to_s
      get_params['cookie'] = @current_config[:cookie_value].to_s
      get_params['ip'] = @current_config[:ip_address].to_s
      get_params['timeout'] = @current_config[:idle_timeout].to_s

      # Identification
      @user.each do |key, value|
        get_params['cv_' + key.to_s] = value.to_s
      end

      if !is_tracking
        url = '/track/identify/?'
      else
        if event[0].nil?
          get_params['event'] = 'pv'
          get_params['ce_url'] = @current_config[:url]
        else
          get_params['event'] = event[0].to_s
          event[1]&.each do |key, value|
            get_params['ce_' + key.to_s] = value.to_s
          end
        end
        url = '/track/ce/?'
      end

      get_params.each do |key, value|
        url += CGI.escape(key) + '=' + CGI.escape(value) + '&'
      end

      url = url[0..-1] + '&ce_app=' + SDK_ID

      http = Net::HTTP.new(base_url)
      user_agent = @current_config[:user_agent]

      req = if !user_agent.nil?
              Net::HTTP::Get.new(url, 'User-Agent' => user_agent)
            else
              Net::HTTP::Get.new(url)
            end

      http.request(req)
    end
  end
end
# :nocov:
