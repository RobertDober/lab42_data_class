# frozen_string_literal: true

require_relative "constraint"
require_relative "setter_constraint"
require_relative "attribute_setters/pair_of_attribute_setter"
module Lab42
  module DataClass
    module Constraints
      class PairOfConstraint < Constraint
        include SetterConstraint

        def attribute_setter = AttributeSetters::PairOfAttributeSetter
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
