# frozen_string_literal: true

module Lab42
  module DataClass
    module Constraints
      module AttributeSetters
        module AttributeSetter
          attr_reader :attribute, :constraint, :instance, :return_setter

          private

          def initialize(attribute:, constraint:, instance:, return_setter: false)
            @attribute = attribute
            @constraint = constraint
            @instance = instance
            @return_setter = return_setter
          end

          def _set_attr!(value)
            new_values = instance.to_h.merge(attribute => value)
            instance.class.send(:_new_from_merge, {}, new_values).tap do |new_instance|
              return return_setter ? new_instance.set(attribute, return_setter: true) : new_instance
            end
          end

          def _value
            @___value__ ||= instance[attribute]
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
