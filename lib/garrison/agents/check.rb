module Garrison
  module Checks
    class Check

      attr_accessor :source
      attr_accessor :severity
      attr_accessor :family
      attr_accessor :type
      attr_accessor :options

      def initialize(options = {})
        @source   = ENV['GARRISON_ALERT_SOURCE']
        @severity = ENV['GARRISON_ALERT_SEVERITY']
        @type     = ENV['GARRISON_ALERT_TYPE']
        @family   = ENV['GARRISON_ALERT_FAMILY']
        @options  = options

        Logging.info "Starting... #{self.class.name}"
        inherit_settings
        Logging.info "Agent Settings (source=#{self.source} severity=#{self.severity} type=#{self.type} family=#{self.family})"

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

      def alert(name:, target:, detail:, finding:, finding_id:, urls: [], key_values: [])
        Logging.info "Raising alert for '#{target}'"

        alert = Api::Alert.new
        alert.type = type
        alert.family = family
        alert.source = source

        alert.name = name
        alert.target = target
        alert.detail = detail
        alert.severity = severity

        alert.finding = finding
        alert.finding_id = finding_id
        alert.detected_at = Time.now.utc

        alert.urls = urls
        alert.key_values = (self.key_values + key_values).uniq { |h| h[:key] }

        alert.save
      end

      private

      def inherit_settings
        settings
      end
    end
  end
end
