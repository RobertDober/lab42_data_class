# frozen_string_literal: true

require_relative "dlist/node"

module Lab42
  class DList
    module ClassMethods

      def new(*elements)
        allocate.tap do |o|
          _set!(o, :length, 0)
          o.freeze
          elements.reduce(o) { |o1, element| o1.append(element) }
        end
      end

      private


      def _set!(o, name, value, &blk)
        return o.instance_variable_set("@#{name}", value)
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
