# frozen_string_literal: true

require_relative 'eq_and_patterns'
module Lab42
  class Pair
    attr_reader :first, :second
    include EqAndPatterns

    def to_a
      [first, second]
    end

    private

    def initialize(first, second)
      @first = first
      @second = second
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
