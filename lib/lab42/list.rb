# frozen_string_literal: true

require_relative "nil"
require_relative "list/class_methods"
module Lab42
  class List
    include Enumerable
    attr_reader :car, :cdr, :length

    def ==(other) =
      self.class.list?(other) &&
        length == other.length &&
        car == other.car &&
        cdr == other.cdr

    def deconstruct = [car, cdr]

    def each(&blk) = self.class.each(self, &blk)

    def empty? = false
  end
end
# SPDX-License-Identifier: Apache-2.0
