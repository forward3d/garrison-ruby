module Garrison
  module Api
    class Run

      class << self
        def create(check)
          url = File.join(Api.configuration.url, 'api', 'v1', 'runs')
          party_params = {
            body: {
              run: {
                agent_id: Api.configuration.uuid,
                started_at: Time.now.utc,
                state: check.state
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' },
            logger: Logging.logger,
            log_level: :debug,
            raise_on: (400..599).to_a
          }

          Logging.debug "Run::create - #{party_params[:body]}"
          response = HTTParty.post(url, party_params)

          Logging.logger.progname = [Api.configuration.uuid, response["id"]].join(",")
          Logging.info "Agent Run Created (uuid=#{response["id"]})"
          response["id"]

        rescue Errno::ECONNREFUSED => e
          Logging.error "#{e.class} to the Garrison API during Run::create - #{e.message}"
        rescue HTTParty::ResponseError => e
          Logging.error "#{e.class} #{e.message.split(" - ")[0]} - When calling the Garrison API during Run::create"
        end

        def update(check)
          url = File.join(Api.configuration.url, 'api', 'v1', 'runs', check.run_uuid)
          party_params = {
            body: {
              run: {
                state: check.state,
                ended_at: Time.now.utc
              }
            }.to_json,
            headers: { 'Content-Type' => 'application/json' },
            logger: Logging.logger,
            log_level: :debug,
            raise_on: (400..599).to_a
          }

          Logging.debug "Run::update - #{party_params[:body]}"
          HTTParty.patch(url, party_params)

        rescue Errno::ECONNREFUSED => e
          Logging.error "#{e.class} to the Garrison API during Run::update - #{e.message}"
        rescue HTTParty::ResponseError => e
          Logging.error "#{e.class} #{e.message.split(" - ")[0]} - When calling the Garrison API during Run::update"
        end
      end

    end
  end
end
