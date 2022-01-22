# frozen_string_literal: true

require_relative './data_class/proxy'

module Kernel
  def DataClass(*args, **kwds, &blk)
    proxy = Lab42::DataClass::Proxy.new(*args, **kwds, &blk)
    proxy.define_class!
  end
end

#  SPDX-License-Identifier: Apache-2.0
