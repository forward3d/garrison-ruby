module Garrison
  module Api
    class Alert

      class << self
        def obsolete_previous_runs(source)
          raise ArgumentError, "No source defined" unless source
          url = File.join(Api.configuration.url, 'api', 'v1', 'alerts', 'obsolete')
          HTTParty.post(
            url,
            body: {
              source: source,
              agent_uuid: Api.configuration.uuid,
              agent_run_uuid: Api.configuration.run_uuid,
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
        end
      end

      attr_accessor :type
      attr_accessor :family
      attr_accessor :source
      attr_accessor :name
      attr_accessor :target
      attr_accessor :detail
      attr_accessor :severity
      attr_accessor :finding
      attr_accessor :finding_id
      attr_accessor :first_detected_at
      attr_accessor :last_detected_at
      attr_accessor :key_values
      attr_accessor :urls
      attr_accessor :departments
      attr_accessor :no_repeat
      attr_accessor :count

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
            first_detected_at: first_detected_at,
            last_detected_at: last_detected_at,
            kind: type,
            family: family,
            source: source,
            severity: severity,
            key_values: key_values,
            urls: urls,
            departments: departments,
            no_repeat: no_repeat,
            count: count,
            agent_uuid: Api.configuration.uuid,
            agent_run_uuid: Api.configuration.run_uuid,
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end
    end
  end
end
