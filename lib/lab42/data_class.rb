# frozen_string_literal: true

require_relative 'lab42/data_class/implementation'

module Lab42
  module DataClass extend self
    def define(in_a_module, *args, **kwds)
      implementation = Lab42::DataClass::Implementation.new(in_a_m
    end
  end
end

class Module
  def dataclass(*args, **kwds)
    Lab42::DataClass.define(self, *args, **kwds)
  end
end
