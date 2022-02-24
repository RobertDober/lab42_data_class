# frozen_string_literal: true

require_relative './data_class/kernel'
require_relative './data_class/constraint_error'
require_relative './data_class/kernel'
require_relative './data_class/validation_error'
require_relative './data_class/proxy'
require_relative './pair'
require_relative './triple'

module Lab42
  module DataClass
    def self.extended extender
    require "debug"; binding.break
    end
    def attributes
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
