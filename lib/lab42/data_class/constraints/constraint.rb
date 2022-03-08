# frozen_string_literal: true

require "lab42/data_class"
module Lab42
  module DataClass
    module Constraints
      class Constraint
        attr_reader :name, :function

        def call(value)
          function.(value)
        end

        def setter_constraint? = false
        def to_proc = function
        def to_s = "Constraint<#{name}>"

        private
        def initialize(name:, function:)
          raise ArgumentError, "name not a String, but #{name}" unless String === name
          unless function.respond_to?(:arity) && function.arity == 1
            raise ArgumentError, "function not a callable with arity 1 #{function}"
          end

          @name = name
          @function = function
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
