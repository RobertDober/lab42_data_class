# frozen_string_literal: true

module Lab42
  module DataClass
    module Constraints
      module SetterConstraint
        attr_reader :constraint

        def setter_constraint? = true

        def setter_for(attribute:, instance:)
          attribute_setter.new(
            attribute:,
            constraint: self,
            instance:
          )
        end
        private

        def initialize(constraint:, **other)
          super(**other)
          @constraint = constraint
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
