# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      module Constraints
        module Maker
          extend self

          def make_constraint(constraint)
            case constraint
            when Proc, Method
              constraint
            when Symbol
              -> { _1.send(constraint) }
            when Array
              -> { _1.send(*constraint) }
            when Regexp
              -> { constraint.match?(_1) }
            when UnboundMethod
              -> { constraint.bind(_1).() }
            else
              _make_memeber_constraint(constraint)
            end
          end

          private

          def _make_memeber_constraint(constraint)
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
