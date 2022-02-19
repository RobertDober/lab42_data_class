# frozen_string_literal: true

module Lab42
  module EqAndPatterns
    def [](idx)
      to_a[idx]
    end

    def ==(other)
      other.is_a?(self.class) &&
        to_a == other.to_a
    end

    def deconstruct(*)
      to_a
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
