# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      module Constraints
        def check_constraints_against_defaults(constraints)
          errors = constraints
                   .map(&_check_constraint_against_default)
                   .compact
          raise ConstraintError, errors.join("\n\n") unless errors.empty?
        end

        def define_constraint
          ->((attr, constraint)) do
            if members.member?(attr)
              constraints[attr] << constraint
              nil
            else
              attr
            end
          end
        end

        private

        def _check_constraint_against_default
          ->((attr, constraint)) do
            if defaults.key?(attr)
              _check_constraint_against_default_value(attr, defaults[attr], constraint)
            end
          end
        end

        def _check_constraint_against_default_value(attr, value, constraint)
          unless constraint.(value)
            "default value #{value.inspect} is not allowed for attribute #{attr.inspect}"
          end
        rescue StandardError => e
          "constraint error during validation of default value of attribute #{attr.inspect}\n  #{e.message}"
        end

        def _check_constraints_for_attr!
          ->((k, v)) do
            constraints[k]
              .map(&_check_constraint!(k, v))
          end
        end

        def _check_constraint!(attr, value)
          ->(constraint) do
            "value #{value.inspect} is not allowed for attribute #{attr.inspect}" unless constraint.(value)
          rescue StandardError => e
            "constraint error during validation of attribute #{attr.inspect}\n  #{e.message}"
          end
        end

        def _check_constraints!(params)
          errors = params
                   .flat_map(&_check_constraints_for_attr!)
                   .compact

          raise ConstraintError, errors.join("\n\n") unless errors.empty?
        end

        def _define_with_constraint
          proxy = self
          ->(*) do
            define_method :with_constraint do |**constraints|
              errors = constraints.map(&proxy.define_constraint).compact
              unless errors.empty?
                raise ArgumentError,
                      "constraints cannot be defined for undefined attributes #{errors.inspect}"
              end

              proxy.check_constraints_against_defaults(constraints)
              self
            end
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
