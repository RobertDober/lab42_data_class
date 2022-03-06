# frozen_string_literal: true

module Lab42
  module DataClass
    module Constraints
      module AttributeSetters
        module AttributeSetter
          attr_reader :attribute, :constraint, :instance

          private

          def initialize(attribute:, constraint:, instance:)
            @attribute = attribute
            @constraint = constraint
            @instance = instance
          end

          def _set_attr!(value)
            new_values = instance.to_h.merge(attribute => value)
            instance.class.send(:_new_from_merge, {}, new_values)
          end

          def _value = @___value__ ||= instance[attribute]
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
