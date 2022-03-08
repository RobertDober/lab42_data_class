# frozen_string_literal: true

module Lab42
  module Nil
    extend self, Enumerable

    def deconstruct
      []
    end

    def each
      self
    end

    def empty?
      true
    end

    def length
      0
    end

    def cons(new_head)
      List.cons(new_head, self)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
