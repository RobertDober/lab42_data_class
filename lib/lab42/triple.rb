# frozen_string_literal: true

require_relative 'eq_and_patterns'
module Lab42
  class Triple
    attr_reader :first, :second, :third
    include EqAndPatterns

    def to_a
      [first, second, third]
    end

    def set_first(new_first) = self.class.new(new_first, second, third)
    def set_second(new_second) = self.class.new(first, new_second, third)
    def set_third(new_third) = self.class.new(first, second, new_third)

    private

    def initialize(first, second, third)
      @first = first
      @second = second
      @third = third
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
