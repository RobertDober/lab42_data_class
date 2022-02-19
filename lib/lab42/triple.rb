# frozen_string_literal: true

require_relative 'eq_and_patterns'
module Lab42
  class Triple
    attr_reader :first, :second, :third
    include EqAndPatterns

    def to_a
      [first, second, third]
    end

    private

    def initialize(first, second, third)
      @first = first
      @second = second
      @third = third
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
