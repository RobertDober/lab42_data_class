# frozen_string_literal: true

require_relative "attribute_setter"
module Lab42
  module DataClass
    module Constraints
      module AttributeSetters
        class PairOfAttributeSetter
          include AttributeSetter

          def first_element(value)
            constraint.constraint.first.(value) or raise ConstraintError,
                                                         "cannot set value #{value} in set(#{attribute}).first_element"

            _set_attr!(_value.set_first(value))
          end

          def second_element(value)
            constraint.constraint.last.(value) or raise ConstraintError,
                                                        "cannot set value #{value} in set(#{attribute}).second_element"
            _set_attr!(_value.set_second(value))
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
