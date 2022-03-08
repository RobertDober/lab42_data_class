# frozen_string_literal: true

require_relative "../../constraints/constraint"
module Lab42
  module DataClass
    class Proxy
      module Constraints
        module Maker
          extend self

          def make_constraint(constraint, &blk)
            raise ArgumentError, "must not pass a callable #{constraint} and a block" if constraint && blk

            _make_constraint(constraint || blk)
          end

          private

          def _make_constraint(constraint)
            case constraint
            when Lab42::DataClass::Constraints::Constraint, Proc, Method
              constraint
            when Symbol
              -> { _1.send(constraint) }
            when Array
              -> { _1.send(*constraint) }
            when Regexp
              -> { constraint.match?(_1) }
            when UnboundMethod
              -> { constraint.bind(_1).() }
            when Module
              -> { constraint === _1 }
            else
              _make_member_constraint(constraint)
            end
          end

          def _make_member_constraint(constraint)
            if constraint.respond_to?(:member?)
              -> { constraint.member?(_1) }
            end
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
