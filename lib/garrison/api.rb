require 'httparty'
require 'garrison/agents/check'
require 'garrison/api/alert'
require 'garrison/api/run'
require 'garrison/api/version'
require 'garrison/helpers/logger'

module Garrison
  module Api
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :url
      attr_accessor :uuid

      def initialize
        @uuid = SecureRandom.uuid
      end
    end
  end
end
