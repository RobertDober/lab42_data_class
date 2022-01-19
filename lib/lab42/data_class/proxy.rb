# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      attr_reader :actual_params, :defaults, :members, :positionals

      def check!(**params)
        @actual_params = params
        raise ArgumentError, "missing initializers for #{_missing_initializers}" unless _missing_initializers.empty?
        raise ArgumentError, "illegal initializers #{_illegal_initializers}" unless _illegal_initializers.empty?
      end

      def init(data_class, **params)
        _init(data_class, defaults.merge(params))
      end

      def to_hash(data_class)
        members
          .map { [_1, data_class.instance_variable_get("@#{_1}")] }
          .to_h
      end

      private
      def initialize(*args, **kwds)
        @defaults = kwds
        # TODO: Check for all symbols and no duplicates
        @positionals = args
        @members = Set.new(args + kwds.keys)
      end

      def _init(data_class, params)
        params.each do |key, value|
          data_class.instance_variable_set("@#{key}", value)
        end
      end

      def _missing_initializers
        @___missing_initializers__ ||=
          positionals - actual_params.keys
      end

      def _illegal_initializers
        @___illegal_initializers__ ||=
          actual_params.keys - positionals - defaults.keys
      end

    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
