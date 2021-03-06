# encoding: UTF-8
module Correios
  module SRO
    class Tracker
      attr_accessor :user, :password
      attr_accessor :query_type, :result_mode
      attr_reader :object_numbers

      DEFAULT_OPTIONS = { :query_type => :list, :result_mode => :last }

      def initialize(options = {})
        DEFAULT_OPTIONS.merge(options).each do |attr, value|
          self.send("#{attr}=", value)
        end

        yield self if block_given?
        @object_numbers = []
      end

      def get(*object_numbers)
        @object_numbers = object_numbers
        response = web_service.request!
        objects = parser.objects(response)

        if @object_numbers.size == 1
          objects.values.first
        else
          objects
        end
      end

      private

      def web_service
        @web_service ||= Correios::SRO::WebService.new(self)
      end

      def parser
        @parser ||= Correios::SRO::Parser.new
      end
    end
  end
end
