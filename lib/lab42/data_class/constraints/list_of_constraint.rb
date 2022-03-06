# frozen_string_literal: true

require_relative "constraint"
require_relative "setter_constraint"
require_relative "attribute_setters/list_of_attribute_setter"
module Lab42
  module DataClass
    module Constraints
      class ListOfConstraint < Constraint
        include SetterConstraint

        def attribute_setter = AttributeSetters::ListOfAttributeSetter
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
