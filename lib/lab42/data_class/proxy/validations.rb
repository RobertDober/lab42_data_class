# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      module Validations
        def validate!(instance)
          errors = validations
                   .map(&_check_validation!(instance))
                   .compact

          raise ValidationError, errors.join("\n") unless errors.empty?
        end

        private

        def _define_with_validations
          proxy = self
          ->(*) do
            define_method :validate do |name = nil, &block|
              proxy.validations << [name, block]
              self
            end
          end
        end

        def _check_validation!(instance)
          ->((name, validation)) do
            unless validation.(instance)
              name || validation
            end
          end
        end
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
