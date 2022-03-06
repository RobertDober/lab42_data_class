# frozen_string_literal: true

require_relative "constraint"
require_relative "setter_constraint"
require_relative "attribute_setters/triple_of_attribute_setter"
module Lab42
  module DataClass
    module Constraints
      class TripleOfConstraint < Constraint
        include SetterConstraint

        def attribute_setter = AttributeSetters::TripleOfAttributeSetter
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
