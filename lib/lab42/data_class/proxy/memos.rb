# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      module Memos
        def all_attributes
          @__all_attributes__ ||= members&.union(Set.new(derived_attributes.keys))
        end

        def constraints
          @__constraints__ ||= Hash.new { |h, k| h[k] = [] }
        end

        def defaults
          @__defaults__ ||= {}
        end

        def derived_attributes
          @__derived_attributes__ ||= {}
        end

        def members
          @__members__ ||= unless (positionals + defaults.keys).empty?
                             Set.new(positionals + defaults.keys)
                           end
        end

        def positionals
          @__positionals__ ||= []
        end

        def validations
          @__validations__ ||= []
        end

        private

        def _missing_initializers
          @___missing_initializers__ ||=
            positionals - actual_params.keys
        end

        def _illegal_initializers
          @___illegal_initializers__ ||=
            actual_params.keys - positionals - defaults.keys
        end
      end
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
