module Garrison
  module Api
    class Alert
      attr_accessor :type
      attr_accessor :family
      attr_accessor :source
      attr_accessor :name
      attr_accessor :target
      attr_accessor :detail
      attr_accessor :severity
      attr_accessor :finding
      attr_accessor :finding_id
      attr_accessor :detected_at
      attr_accessor :key_values
      attr_accessor :urls

      def initialize; end

      def save
        url = File.join(Api.configuration.url, 'api', 'v1', 'alerts')
        HTTParty.post(
          url,
          body: {
            name: name,
            target: target,
            detail: detail,
            finding: finding,
            finding_id: finding_id,
            detected_at: detected_at,
            kind: type,
            family: family,
            source: source,
            severity: severity,
            key_values: key_values,
            urls: urls
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
    end
  end
end
