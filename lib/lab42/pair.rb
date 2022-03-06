# frozen_string_literal: true

require_relative 'eq_and_patterns'
module Lab42
  class Pair
    attr_reader :first, :second
    include EqAndPatterns

    def to_a
      [first, second]
    end

    def set_first(new_first) = self.class.new(new_first, second)
    def set_second(new_second) = self.class.new(first, new_second)

    private

    def initialize(first, second)
      @first = first
      @second = second
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
