# frozen_string_literal: true

require 'set'
require_relative './data_class/proxy'

module Kernel
  def DataClass(*args, **kwds, &blk)
    proxy = Lab42::DataClass::Proxy.new(*args, **kwds)
    klass = Class.new do
      attr_reader(*proxy.members)
      define_method :initialize do |**params|
        proxy.check!(**params)
        proxy.init(self, **params)
      end

      define_method :merge do |**params|
        values = to_h.merge(**params)
        DataClass(*proxy.positionals, **proxy.defaults, &blk)
          .new(**values)
      end

      define_method :to_h do
        proxy.to_hash(self)
      end
    end
    klass.module_eval(&blk) if blk
    klass
  end
end

#  SPDX-License-Identifier: Apache-2.0
