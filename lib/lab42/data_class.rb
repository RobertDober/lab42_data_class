# frozen_string_literal: true

require_relative './data_class/proxy'
require_relative './pair'
require_relative './triple'

module Kernel
  def DataClass(*args, **kwds, &blk)
    proxy = Lab42::DataClass::Proxy.new(*args, **kwds, &blk)
    proxy.define_class!
  end

  def Pair(first, second)
    Lab42::Pair.new(first, second)
  end

  def Triple(first, second, third)
    Lab42::Triple.new(first, second, third)
  end
end

#  SPDX-License-Identifier: Apache-2.0
