module Garrison
  module Api
    class Alert

      class << self
        def obsolete_previous_runs(check)
          raise ArgumentError, "No source defined" unless check.source
          url = File.join(Api.configuration.url, 'api', 'v1', 'alerts', 'obsolete')

          party_params = {
            body: {
              source: check.source,
              agent_id: Api.configuration.uuid,
              run_id: check.run_uuid,
            }.to_json,
            headers: { 'Content-Type' => 'application/json' },
            logger: Logging.logger,
            log_level: :debug,
            raise_on: (400..599).to_a
          }

          Logging.debug "Alert::obsolete_previous_runs - #{party_params[:body]}"
          HTTParty.post(url, party_params)

        rescue Errno::ECONNREFUSED => e
          Logging.error "#{e.class} to the Garrison API during Alert::obsolete_previous_runs - #{e.message}"
        rescue HTTParty::ResponseError => e
          Logging.error "#{e.class} #{e.message.split(" - ")[0]} - When calling the Garrison API during Alert::obsolete_previous_runs"
        end
      end

      attr_accessor :run_uuid
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

        party_params = {
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
            agent_id: Api.configuration.uuid,
            run_id: run_uuid,
          }.to_json,
          headers: { 'Content-Type' => 'application/json' },
          logger: Logging.logger,
          log_level: :debug,
          raise_on: (400..599).to_a
        }

        Logging.debug "Alert::save - #{party_params[:body]}"
        HTTParty.post(url, party_params)

      rescue Errno::ECONNREFUSED => e
        Logging.error "#{e.class} to the Garrison API during Alert::save - #{e.message}"
      rescue HTTParty::ResponseError => e
        Logging.error "#{e.class} #{e.message.split(" - ")[0]} - When calling the Garrison API during Alert::save"
      end
    end
  end
end
