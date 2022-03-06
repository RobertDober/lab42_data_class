# frozen_string_literal: true

module Lab42
  module Nil
    extend self, Enumerable

    def deconstruct = []
    def each = self
    def empty? = true
    def length = 0
  end
end
# SPDX-License-Identifier: Apache-2.0
