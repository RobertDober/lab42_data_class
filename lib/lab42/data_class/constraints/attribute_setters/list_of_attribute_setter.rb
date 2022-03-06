# frozen_string_literal: true

require_relative "attribute_setter"
module Lab42
  module DataClass
    module Constraints
      module AttributeSetters
        class ListOfAttributeSetter
          include AttributeSetter

          def cons(value)
            constraint.constraint.(value) or raise ConstraintError,
                                                   "cannot set value #{value} in set(#{attribute}).cons"

            _set_attr!(_value.cons(value))
          end

          def cdr
            _set_attr!(_value.cdr)
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
