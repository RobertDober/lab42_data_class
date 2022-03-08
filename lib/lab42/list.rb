# frozen_string_literal: true

require_relative "nil"
require_relative "list/class_methods"
module Lab42
  class List
    include Enumerable
    attr_reader :car, :cdr, :length

    def ==(other)
      self.class.list?(other) &&
        length == other.length &&
        car == other.car &&
        cdr == other.cdr
    end

    def cadr
      cdr.car
    end

    def caddr
      cdr.cdr.car
    end

    def cddr
      cdr.cdr
    end

    def cdddr
      cdr.cdr.cdr
    end

    def cons(new_head)
      self.class.cons(new_head, self)
    end

    def deconstruct
      [car, cdr]
    end

    def each(&blk)
      self.class.each(self, &blk)
    end

    def empty?
      false
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
