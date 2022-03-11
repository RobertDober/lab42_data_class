# frozen_string_literal: true

module Lab42
  class DList
    class Node
      attr_reader :content, :nxt, :prv

      def with(nxt, prv=nil)
        self.class.new(content, nxt || self.nxt, prv || self.prv)
      end

      private
      def initialize(content, nxt=nil, prv=nil)
        @content = content
        @nxt = nxt
        @prv = prv
        freeze
      end
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
