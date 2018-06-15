require 'httparty'
require 'garrison/api/version'
require 'garrison/api/alert'
require 'garrison/agents/check'
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

      def initialize
      end
    end
  end
end