# frozen_string_literal: true

require_relative "dlist/class_methods"
require_relative "dlist/node"
module Lab42
  class DList
    extend ClassMethods

    NotYetImplemented = Class.new RuntimeError

    attr_reader :first, :last, :length

    def empty?
      length.zero?
    end

    def append(element)
      if self.class === element
        raise NotYetImplemented, "append two DLists not needed yet"
      else
        append_new_node(element)
      end
    end

    private
    def append_new_node(element)
      n = Node.new(element, first, last)
      if first
      else
        n = n.with(
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
