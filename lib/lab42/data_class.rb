# frozen_string_literal: true

require_relative './data_class/constraint_error'
require_relative './data_class/kernel'
require_relative './data_class/validation_error'
require_relative './data_class/proxy'
require_relative './pair'
require_relative './triple'

module Lab42
  module DataClass
    def self.extended(extender)
      proxy = Proxy.new(extender)

      extender.module_eval do
        define_singleton_method(:__data_class_proxy__){ proxy }
      end
    end

    def attributes(*args, **kwds)
      __data_class_proxy__.tap do |proxy|
        proxy.update!(args, kwds)
        proxy.define_class!
      end
    end

    def constraint(member, constraint = nil, &block)
      raise ArgumentError, "must not provide constraint (2nd argument) and a block" if block && constraint

      __data_class_proxy__.define_constraints(member => constraint || block)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
