module Garrison
  module Checks
    class Check

      attr_accessor :source
      attr_accessor :severity
      attr_accessor :type
      attr_accessor :family
      attr_accessor :departments
      attr_accessor :options

      def initialize(options = {})
        @source      = ENV['GARRISON_ALERT_SOURCE']
        @severity    = ENV['GARRISON_ALERT_SEVERITY']
        @type        = ENV['GARRISON_ALERT_TYPE']
        @family      = ENV['GARRISON_ALERT_FAMILY']
        @departments = ENV['GARRISON_ALERT_DEPARTMENTS'] ? ENV['GARRISON_ALERT_DEPARTMENTS'].split(',') : []
        @options     = options

        Logging.info "Starting... #{self.class.name}"
        inherit_settings
        Logging.info "Agent Settings (source=#{self.source} severity=#{self.severity || 'dynamic'} type=#{self.type} family=#{self.family} departments=#{self.departments.join(',')})"

        options_log = options.map do |key, value|
          value = value.is_a?(Array) ? value.join(',') : value
          "#{key}=#{value}"
        end
        Logging.info "Check Settings (#{options_log.join(' ')})" if options.any?
      end

      def perform
        raise 'You must provide a perform method in your check class'
      end

      def key_values
        []
      end

      def alert(params = {})
        Logging.info "Raising alert for '#{params[:target]}'"
        utc_time_now = Time.now.utc

        alert = Api::Alert.new
        alert.type = type
        alert.family = family
        alert.source = source
        alert.departments = departments

        alert.name = params[:name]
        alert.target = params[:target]
        alert.detail = params[:detail]
        alert.severity = params[:external_severity] || severity
        alert.count = params[:count] || 1

        alert.finding = params[:finding]
        alert.finding_id = params[:finding_id]
        alert.first_detected_at = params[:first_detected_at] || utc_time_now
        alert.last_detected_at = params[:last_detected_at] || utc_time_now

        alert.urls = params[:urls]
        alert.key_values = (self.key_values + params[:key_values]).uniq { |h| h[:key] }

        alert.no_repeat = params[:no_repeat]

        alert.save
      end

      private

      def inherit_settings
        settings
      end
    end
  end
end
