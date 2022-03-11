# frozen_string_literal: true

require_relative '../nil'
module Kernel
  Nil = Lab42::Nil

  def DataClass(*args, **kwds, &blk)
    proxy = Lab42::DataClass::Proxy.new(*args, **kwds, &blk)
    proxy.define_class!
  end

  def DList(*elements)
    Lab42::DList.new(*elements)
  end

  def List(*elements)
    Lab42::List.new(*elements)
  end

  def Pair(first, second)
    Lab42::Pair.new(first, second)
  end

  def Triple(first, second, third)
    Lab42::Triple.new(first, second, third)
  end
end
#  SPDX-License-Identifier: Apache-2.0
