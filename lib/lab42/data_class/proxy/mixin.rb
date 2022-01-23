# frozen_string_literal: true

module Lab42
  module DataClass
    class Proxy
      module Mixin
        def ==(other)
          other.is_a?(self.class) &&
            to_h == other.to_h
        end

        def deconstruct_keys(*)
          to_h
        end
      end
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
